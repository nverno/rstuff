### plotting_ui.R --- 
## Filename: plotting_ui.R
## Description: Reusable plotting UI elements
## Author: Noah Peart
## Created: Thu Oct 22 22:58:19 2015 (-0400)
## Last-Updated: Thu Oct 22 23:09:19 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'vis'

################################################################################
##
##                             Splitting Panels
##
################################################################################
tpSplitChoices <- names(isolate(visVals$tpSplitOpts))
ppSplitChoices <- names(isolate(visVals$ppSplitOpts))

visSplit <- tagList(
    conditionalPanel(
        condition = "input.data == 'tp'",

        checkboxGroupInput('tpVisSplit', 'Split Panels:',
                           choices=tpSplitChoices,
                           selected = 'Transects', inline=TRUE),
        conditionalPanel(
            condition = "input.tpVisSplit.length > 0 && input.tpVisSplit.length != 3",
            checkboxGroupInput('tpVisSplitBy', 'By:',
                               choices=tpSplitChoices,
                               selected = c('Plots', 'Years'), inline=TRUE)
        )
    ),
    conditionalPanel(
        condition = "input.data == 'pp'",
        checkboxGroupInput('ppVisSplit', 'Split Panels:',
                           choices=ppSplitChoices,
                           selected = 'Plots', inline=TRUE),
        conditionalPanel(
            condition = paste0("input.ppVisSplit.length > 0 && input.ppVisSplit.length !=",
                length(ppSplitChoices)),
            checkboxGroupInput('ppVisSplitBy', 'By:',
                               choices=ppSplitChoices,
                               selected = 'Years', inline=TRUE)
        )
    )
)
