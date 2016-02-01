### ui.R --- 
## Filename: ui.R
## Description: 
## Author: Noah Peart
## Created: Mon Oct 26 14:18:06 2015 (-0400)
## Last-Updated: Mon Oct 26 14:19:35 2015 (-0400)
##           By: Noah Peart
######################################################################
fluidPage(
    sidebarLayout(
        sidebarPanel(
            selectInput("stu","Choose Student",
                        choice = unique(df$Student))
        ),
        mainPanel(ggvisOutput("plot"))
    )
)

