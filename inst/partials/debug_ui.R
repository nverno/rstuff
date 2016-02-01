### debugUI.R --- 
## Filename: debugUI.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 21 02:47:17 2015 (-0400)
## Last-Updated: Wed Oct 21 20:02:47 2015 (-0400)
##           By: Noah Peart
######################################################################

fluidRow(
    tagList(
        textInput('debugInput', "Debug input:", ''),
        fluidRow(
            column(2, actionButton('debug', 'Debug')),
            column(2, actionButton('sessionNames', 'Names')),
            column(2, actionButton('sessionValues', 'Values'))
        ),
        verbatimTextOutput('debugOutput')
    )
)
