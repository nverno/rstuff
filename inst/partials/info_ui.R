### info_ui.R --- 
## Filename: info_ui.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 27 15:32:30 2015 (-0400)
## Last-Updated: Tue Oct 27 15:34:31 2015 (-0400)
##           By: Noah Peart
######################################################################

fluidPage(
    conditionalPanel(
        condition = "input.data == 'pp'",
        includeMarkdown('info/pp_info.md')),
    conditionalPanel(
        condition = "input.data == 'tp'",
        includeMarkdown('info/tp_info.md')
    )
)
