### subset_ui.R --- 
## Filename: subset_ui.R
## Description: Main subset UI
## Author: Noah Peart
## Created: Thu Oct 22 19:13:14 2015 (-0400)
## Last-Updated: Sat Oct 31 15:17:41 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: ''

subsetOptions <- tagList(
    radioButtons('data', 'Data:', choices=c('Permanent Plots'='pp', 'Transects'='tp'),
                 selected=isolate(values$data) %||% 'pp', inline=TRUE),
    hr(),
    
    conditionalPanel(
        condition = "input.data == 'tp'",
        source(file.path('partials', 'subset_transect_ui.R'), local=TRUE)$value
    ),
    conditionalPanel(
        condition = "input.data == 'pp'",
        source(file.path('partials', 'subset_permanent_ui.R'), local=TRUE)$value
    )
    ## DT::dataTableOutput('dataTable')
)
