### plotting.R --- 
## Filename: plotting.R
## Description: Controllers usefull in many plots
## Author: Noah Peart
## Created: Thu Oct 22 22:52:03 2015 (-0400)
## Last-Updated: Thu Oct 22 22:54:02 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'vis'
visVals <- reactiveValues(
    tpSplitOpts = c('Transects'='TRAN', 'Plots'='TPLOT', 'Years'='YEAR'),
    ppSplitOpts = c('Plots'='PPLOT', 'Years'='YEAR')
)

################################################################################
##
##                                Facetting 
##
################################################################################
## Create formula from splitting input for facet_grid with ggplot
splitForm <- function() {
    prefix <- input$data
    split1 <- paste0(prefix, 'VisSplit')
    split2 <- paste0(prefix, 'VisSplitBy')
    vals <- isolate({ if (prefix=='tp') visVals$tpSplitOpts else visVals$ppSplitOpts })

    if (length(input[[split1]]) > 0) {
        lhs <- paste(vals[input[[split1]]], collapse = '+')
        rhs <- if (length(input[[split1]]) < length(vals) && length(input[[split2]]) > 0) {
            paste(vals[input[[split2]]], collapse='+')
        } else '.'
        print(sprintf("%s ~ %s", lhs, rhs))
        return( facet_grid(as.formula(sprintf("%s ~ %s", lhs, rhs))) )
    }
    return ( list( ) )
}

## Update splitting options
observeEvent(input$tpVisSplit, {
    choices <- names(visVals$tpSplitOpts)[!(names(visVals$tpSplitOpts) %in% input$tpVisSplit)]
    updateCheckboxGroupInput(
        session,
        inputId='tpVisSplitBy',
        choices=choices,
        selected=input[['tpVisSplitBy']],
        inline=TRUE
    )
}, ignoreNULL = FALSE)

observeEvent(input$ppVisSplit, {
    choices <- names(visVals$ppSplitOpts)[!(names(visVals$ppSplitOpts) %in% input$ppVisSplit)]
    updateCheckboxGroupInput(
        session,
        inputId='ppVisSplitBy',
        choices=choices,
        selected=input[['ppVisSplitBy']],
        inline=TRUE
    )
}, ignoreNULL = FALSE)
