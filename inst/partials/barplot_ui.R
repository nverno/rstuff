### barplot_ui.R --- 
## Filename: barplot_ui.R
## Description: 
## Author: Noah Peart
## Created: Thu Oct 22 20:33:47 2015 (-0400)
## Last-Updated: Fri Oct 23 14:13:09 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'bplt'

################################################################################
##
##                     Barplot w/ DBH size class options
##
################################################################################
bpltSizeOpts <- tagList(
    helpText('Graphing Options'),

    ## Splitting Panels (from plotting_ui)
    visSplit,
    
    ## DBH Breaks
    numericInput('bpltDBHWidth', 'Width of DBH classes', value=5, min=0)
)

## Sidebar Layout
fluidPage(
    sidebarLayout(
        sidebarPanel(
            bpltSizeOpts
        ),
        mainPanel(
            plotOutput('bpltDBHSizeClass')
        )
    )
)
