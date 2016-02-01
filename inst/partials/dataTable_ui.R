### dataTable_ui.R --- 
## Filename: dataTable_ui.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 27 18:47:13 2015 (-0400)
## Last-Updated: Tue Oct 27 18:48:09 2015 (-0400)
##           By: Noah Peart
######################################################################

fluidPage(
    DT::dataTableOutput('dataTable')
)
