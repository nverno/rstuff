### motion_ui.R --- 
## Filename: motion_ui.R
## Description: 
## Author: Noah Peart
## Created: Fri Oct 23 06:41:53 2015 (-0400)
## Last-Updated: Fri Oct 23 13:13:58 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'goog'

fluidPage(
    sidebarLayout(
        sidebarPanel(
            textInput('tmp', 'Temp')
        ),
        mainPanel(
            htmlOutput('googMotion')
        )
    )
)
    
