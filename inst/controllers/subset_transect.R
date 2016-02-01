### subset_transect.R --- 
## Filename: subset_transect.R
## Description: Reactive elements associated with subset_transect_ui.R
## Author: Noah Peart
## Created: Wed Oct 21 16:40:12 2015 (-0400)
## Last-Updated: Sat Oct 31 15:12:00 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'tp'
tpVals <- reactiveValues(tplots=NULL, tpDat=tp)  # use this to store TPLOT/TRAN

## Create checkbox input for the TPLOT separately for each selected TRAN
## Note: might be nice to have these side by side vertically
output$tpPlotChecks <- renderUI({
    lapply(input$tpSideTran, function(x) {
        name <- sprintf('tpTran%sTPlot', paste(x))
        sel <- if (x %in% input$tpSideTran) input[[name]] else NULL
        checkboxGroupInput(name,
                           paste0(x,':'),
                           choices = tpVals$tplots[[x]],
                           selected = sel, inline=TRUE)
    })
})

## NOTE: this should all be isolated - only happen when hidden
## Display a summary of the chosen options when the subsetting interface is
## hidden
output$tpSubsetSummary <- renderUI({
    elev <- if (input$tpSideElevType == 'range') {
        paste(input$tpSideElevRange, collapse="-")
    } else paste(input$tpSideElevClass, collapse=", ")

    ## Only summarize transects that have plots selected
    inds <- sapply(input$tpSideTran, function(x) length(input[[sprintf("tpTran%sTPlot", x)]])>0)
    trans <- input$tpSideTran[inds]
    if (length(trans) < 1) return(helpText('No plots selected.'))
    
    list(
        helpText('This is a summary of the selected options.'),
        HTML(c(
            '<p><span style="font-weight:bold;">Selected</span>:',
            '<ul>',
            paste0(
                '<li>',
                lapply(trans, function(x)
                    sprintf('<span style="font-weight:500;">%s</span> [ %s ]',
                            paste(x),
                            paste(input[[sprintf("tpTran%sTPlot", x)]], collapse=','))),
                '</li>'
            ),
            '</ul>',
            '<span style="font-weight:bold;">Elevation</span>: ', elev,        
            '</p>'
        ))
    )
})

################################################################################
##
##                           Observers for sidebar
##
################################################################################
## Helpers to check groups of transects by aspect
observeEvent(input$tpSideAsp,
             updateCheckboxGroupInput(
                 session,
                 inputId = 'tpSideTran',
                 selected=levels(droplevels(tpAgg$TRAN[tpAgg$ASPCL %in% input$tpSideAsp])),
                 inline=TRUE
             ), ignoreNULL = FALSE)

## Deselect TPLOT boxes when TRAN is unselected
observeEvent(input$tpSideReset, tpVals$tplots <- NULL)

## Only show plots available for each transect for elevation ranges/classes
## Creates a reactive value, 'tplots', that is used to make the interface
observe({
    input$tpSideTran
    input$tpSideElevType
    input$tpSideElevRange
    input$tpSideElevClass

    isolate({
        ## The first null check ensures there is no initial error (before interface is rendered)
        if (!is.null(input$tpSideElevType)) {
            with(tpAgg, {
                elev <- if (input$tpSideElevType == 'range') {
                    ELEV >= input$tpSideElevRange[1] & ELEV <= input$tpSideElevRange[2]
                } else ELEVCL %in% input$tpSideElevClass

                inds <- elev & TRAN %in% input$tpSideTran
                tpVals$tplots <- lapply(split(TPLOT[inds], TRAN[inds]), unique)
            })
        }
    })
})

################################################################################
##
##                                Data!!!
##
################################################################################
## Update data in response to 'tpMake' button
## tpDat <- reactive({
##     input$tpMake
##     isolate({
##         inds <- with(tp, {
##             Reduce('|', lapply(input$tpSideTran, function(x)
##                 TRAN == x & TPLOT %in% input[[sprintf('tpTran%sTPlot', paste(x))]]))
##         })
##         if (!is.null(inds))
##             lb$set_keys(sum(inds))
##         tp[inds,]
##     })
## })
observeEvent(input$tpMake, {
    if (.debug) print("created tpVals")
    inds <- with(tp, {
        Reduce('|', lapply(input$tpSideTran, function(x)
            TRAN == x & TPLOT %in% input[[sprintf('tpTran%sTPlot', paste(x))]]))
    })
    tpVals$tpDat <- tp[inds,]
})

## Work around for broken ggvis parts
tpDat <- reactive({
    if (.debug) print("Created tpDat()")
    dat <- tpVals$tpDat
    if (is.null(dat) || nrow(dat) < 1) dat <- tp[0,]
    dat
})
