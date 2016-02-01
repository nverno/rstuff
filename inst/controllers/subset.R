### subset.R --- 
## Filename: subset.R
## Description: Controllers for partials/subset_ui.R
## Author: Noah Peart
## Created: Thu Oct 22 19:25:37 2015 (-0400)
## Last-Updated: Sat Oct 31 15:18:54 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: ''

dat <- reactive({
    res <- if (is.null(input$data)) {
        blankDF(pp, tp) 
    } else if (!is.null(ppVals$ppDat) && input$data == 'pp') {
        if (.debug) print('Changed dat() to ppDat')
        ppDat()
    } else if (!is.null(tpVals$tpDat) && input$data == 'tp') {
        if (.debug) print('Changed dat() to tpDat')
        tpDat()
    } 

    ## Set values related to ggvis inputs on data change
    lb$set_keys(seq_len(nrow(res)))
    
    res
})

################################################################################
##
##                                 Obsevers
##
################################################################################
## So returning to selection UI, current data is not forgotten
observeEvent(input$data, values$data <- input$data)
