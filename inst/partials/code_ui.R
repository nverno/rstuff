### code_ui.R --- 
## Filename: code_ui.R
## Description: 
## Author: Noah Peart
## Created: Sun Nov  1 00:11:18 2015 (-0400)
## Last-Updated: Sun Nov  1 01:56:36 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'code'

modes <- getAceModes()
themes <- getAceThemes()
hotkeys <- list(
    helpKey='F1',
    runKey=list(win='Ctrl-R|Ctrl-Shift-Enter',
                mac='CMD-ENTER|CMD-SHIFT-ENTER')
)

codeOpts <- tagList(
    fluidRow(
        id='code-panel-controls', class='leaf-control-panel collapse',
        style='padding:15px; right:5%;',
        selectInput('codeMode', 'Mode', choices=modes, selected='r'),
        selectInput('codeTheme', 'Theme', choices=themes, selected='solarized_dark'),
        actionButton('codeEval', 'Eval', width="100%", style='padding:4px; font-size:80%;')
    )
)

codePanel <- tagList(
    div(style='right:2%;top:10%;position:fixed;z-index:2',
        tags$a(href="#", shiny::icon('gears'), `data-toggle`='collapse',
               `data-target`='#code-panel-controls',
               class='btn btn-default',
               style='text-align:center; vertical-align:middle; display:inline-block; 
color: grey; background-color: transparent; border-color: transparent; font-weight:bold')),
    fluidRow(
        id = 'code-panel',
        aceEditor('codeCode', mode='r', theme='solarized_dark', value='## Ctrl-Enter or Ctrl-R',
                  hotkeys = hotkeys)
    )
)

bootstrapPage(
    codeOpts,
    codePanel,
    hr(),
    verbatimTextOutput('codeOutput')
)
