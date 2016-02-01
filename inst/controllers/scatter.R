### scatter.R --- 
## Filename: scatter.R
## Description: Scatterplot controllers
## Author: Noah Peart
## Created: Thu Oct 22 23:26:30 2015 (-0400)
## Last-Updated: Thu Oct 22 23:30:51 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'scat'

scatDat <- reactive({
    samp <- dat()
    if (nrow(samp)<1) return()
    if (.debug) print('Changed scatDat()')
    samp[samp$STAT == 'ALIVE',]
})

output$scatBasic <- renderPlot({
    if (is.null(scatDat())) return()

    p <- ggplot(scatDat(), aes_string(input$scatX, input$scatY)) +
      geom_point() +
      splitForm() + defaults

    p
})
