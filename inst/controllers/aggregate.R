### aggregate.R --- 
## Filename: aggregate.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 27 19:02:17 2015 (-0400)
## Last-Updated: Tue Oct 27 19:57:28 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'agg'

## Apply the aggregation
output$aggTable <- renderTable({
    dd <- dat()
    lhs <- if (length(input$aggVar) > 1) {
        sprintf("cbind(%s)", paste(input$aggVar, collapse=","))
    } else input$aggVar
    form <- as.formula(paste0(lhs, "~", paste(input$aggGroup, collapse="+")))
    res <- aggregate(form, data=dd, FUN=input$aggFun)

    print(format(res, scientific = input$aggScientific %||% FALSE, digits=input$aggDigits))
})
