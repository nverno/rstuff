### scatter_ui.R --- 
## Filename: scatter_ui.R
## Description: Scatterplot UI
## Author: Noah Peart
## Created: Thu Oct 22 23:07:46 2015 (-0400)
## Last-Updated: Thu Oct 22 23:54:40 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'scat'

scatOpts <- tagList(
    helpText("Scatterplot Options"),
    selectInput('scatX', 'X variable:', choices=isolate(names(dat())), selected="DBH"),
    selectInput('scatY', 'Y variable:', choices=isolate(names(dat())), selected="HT"),

    ## Splitting
    visSplit,

    ## Smooth
    checkboxInput('scatSmooth', 'Add Fit/Spline'),
    conditionalPanel(
        condition = "input.scatSmooth == 'true'",
        selectInput('scatSmoothType', 'Fit type:',
                    choices=c('Linear'='lm', 'Loess'='loess', 'Other'='other'), selected='lm'),
        conditionalPanel(
            condition = "input.scatSmoothType == 'other'",
            textInput('scatSmoothModel', 'Enter model formula:')
        )
    )
)


## Sidebar Layout
fluidPage(
    sidebarLayout(
        sidebarPanel(
            scatOpts
        ),
        mainPanel(
            plotOutput('scatBasic')
        )
    )
)
