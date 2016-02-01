### debug.R --- 
## Filename: debug.R
## Description: Output debugging information
## Author: Noah Peart
## Created: Wed Oct 21 01:30:37 2015 (-0400)
## Last-Updated: Wed Oct 21 20:06:57 2015 (-0400)
##           By: Noah Peart
######################################################################

## Print out debug info
debugShiny <- function(action) {
    debugVals$debugText <- isolate({
        if (action == 'sessionNames') {
            names(session$input)
        } else if (action == 'sessionValues') {
            sapply(names(session$input), function(x) input[[x]])
        } else
            tryCatch(eval(parse(text=input$debugInput)),
                     error=function(e) "Bad Things")
    })
}

output$debugOutput <- renderPrint({
    input$sessionNames; input$sessionValues; input$debug
    debugVals$debugText
})

debugVals <- reactiveValues(debugText="")

observeEvent(input$sessionNames, debugShiny('sessionNames'))
observeEvent(input$sessionValues, debugShiny('sessionValues'))
observeEvent(input$debug, debugShiny('debug'))

