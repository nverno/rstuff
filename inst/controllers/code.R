### code.R --- 
## Filename: code.R
## Description: Add an aceEditor code panel
## Author: Noah Peart
## Created: Sun Nov  1 00:18:47 2015 (-0400)
## Last-Updated: Mon Feb  1 14:57:26 2016 (-0500)
##           By: Noah Peart
######################################################################
## Prefix: 'code'
output$codeOutput <- renderPrint({
    input$codeEval
    input$runKey
    isolate(eval(parse(text=input$codeCode)))
})

observeEvent(input$codeMode, updateAceEditor(session, 'codeCode', mode=input$codeMode))
observeEvent(input$codeTheme, updateAceEditor(session, 'codeCode', theme=input$codeTheme))
