### aggregate_ui.R --- 
## Filename: aggregate_ui.R
## Description: Aggregate data in various ways
## Author: Noah Peart
## Created: Tue Oct 27 19:02:00 2015 (-0400)
## Last-Updated: Tue Oct 27 19:59:04 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'agg'

## Need grouping variables, variables to aggregate, function to aggregate by
vars <- isolate(names(dat()))

funs <- c("Mean"="mean", "Sum"="sum", "Total Count"="length", "Unique"="unique")

aggOpts <- tagList(
    selectizeInput('aggGroup', 'Grouping Variables:', choices=vars, multiple=TRUE),
    selectizeInput('aggVar', 'Variables to Aggregate', choices=vars, multiple=TRUE),
    selectizeInput('aggFun', 'Summary Functions:', choices=funs, multiple=TRUE),
    br(),
    helpText("Text formatting options:"),
    checkboxInput('aggScientific', 'Scientific format'),
    numericInput('aggDigits', 'Digits', min=1, value=2, step=1)
)

fluidPage(
    sidebarLayout(
        sidebarPanel(
            aggOpts
        ),
        mainPanel(
            tableOutput('aggTable')
        )
    )
)
