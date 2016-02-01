### subset_permanent.R --- 
## Filename: subset_permanent.R
## Description: 
## Author: Noah Peart
## Created: Thu Oct 22 17:07:13 2015 (-0400)
## Last-Updated: Sat Oct 31 15:06:46 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'pp'
ppVals <- reactiveValues(pplots=levels(ppAgg$PPLOT), ppPlot=levels(ppAgg$PPLOT), ppDat=pp)

## Display a summary of the chosen options when the subsetting interface is
## hidden, these rely on values stored in ppVals when the partial changes
output$ppSubsetSummary <- renderUI({
    if (!is.null(ppVals$ppDat)) {
        isolate({
            elev <- if ((ppVals$ppElevType %||% input$ppElevType) == 'range') {
                paste((ppVals$ppElevRange %||% input$ppElevRange), collapse="-")
            } else paste((ppVals$ppElevClass %||% input$ppElevClass), collapse=", ")
            asps <- paste((ppVals$ppAsp %||% input$ppAsp), collapse = ", ")
            soils <- paste((ppVals$ppSoilClass %||% input$ppSoilClass), collapse = ", ")
            plots <- paste((ppVals$ppPlot %||% input$ppPlot), collapse=", ")

            if (length(plots) < 1) return(helpText('No plots selected.'))
            
            list(
                helpText('Current subset:'),
                HTML(c(
                    '<p><span style="font-weight:bold;">Plots</span>:', plots, '<br>',
                    '<span style="font-weight:bold;">Elevation</span>: ', elev, '<br>',
                    '<span style="font-weight:bold;">Aspect</span>: ', asps, '<br>',
                    '<span style="font-weight:bold;">Soil Classes</span>: ', soils,
                    '</p>'
                ))
            )
        })
    } else {
        helpText("No subset currently.")
    }
})

################################################################################
##
##                                 Observers
##
################################################################################
## Selectors for plot checkboxes
observeEvent(input$ppAllPlots,
updateCheckboxGroupInput(session, inputId='ppPlot', selected=ppVals$pplots, inline=TRUE))
observeEvent(input$ppNonePlots,
updateCheckboxGroupInput(session, inputId='ppPlot',
                         choices=ppVals$pplots, selected=NULL, inline=TRUE))

## Only show plots available for each elev
observe({
    input$ppSoilClass
    input$ppAsp
    input$ppElevType
    input$ppElevRange
    input$ppElevClass

    isolate({
        ## The first null check ensures there is no initial error (before interface is rendered)
        if (!is.null(input$ppElevType)) {
            with(ppAgg, {
                elev <- if (input$ppElevType == 'range') {
                    ELEV >= input$ppElevRange[1] & ELEV <= input$ppElevRange[2]
                } else ELEVCL %in% input$ppElevClass
                inds <- (SOILCL %in% input$ppSoilClass) & (ASPCL %in% input$ppAsp) & elev

                opts <- levels(droplevels(PPLOT[inds]))
                ppVals$pplots <- opts
                if (is.null(opts) || length(opts) < 1) opts <- 'none'
                
                sel <- input$ppPlot[input$ppPlot %in% opts]
                updateCheckboxGroupInput(
                    session,
                    inputId = 'ppPlot', choices=opts, selected=sel, inline=TRUE
                )
            })
        }
    })
})

################################################################################
##
##                                   Data
##
################################################################################
observeEvent(input$ppMake, {
    if (.debug) print("created ppVals")
    captureInputs('pp', ppVals, isolate(session$input))
    inds <- with(pp, PPLOT %in% input$ppPlot)
    ppVals$ppDat <- pp[inds,]
})

## Work around for broken ggvis parts
ppDat <- reactive({
    if (.debug) print("Created ppDat()")
    dat <- ppVals$ppDat
    if (is.null(dat) || nrow(dat) < 1) dat <- pp[0,]
    dat
})

