### subset_transect_ui.R --- 
## Filename: subset_transect_ui.R
## Description: UI elements for subsetting from transects
## Author: Noah Peart
## Created: Wed Oct 21 16:15:59 2015 (-0400)
## Last-Updated: Thu Oct 22 23:23:08 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'tp'

## Globals:
## Transect data is called 'tp'
## Aggregated summary is 'tpAgg'

tpERange <- range(tp$ELEV, na.rm=TRUE)

## Main transect subsetting options
tpSubsetOptions <- tagList(
    fluidRow(
        column(6, 
               checkboxGroupInput('tpSideTran', 'Transect:', choices=levels(tpAgg$TRAN),
                                  selected=NULL, inline=TRUE)
               ),
        column(6, class='col-sm-6 verticalLine',
               helpText('Use these to select transect boxes.'),
               
               ## Aspect
               checkboxGroupInput('tpSideAsp', 'Aspect:',
                                  choices = levels(tpAgg$ASPCL), inline=TRUE),
               
               ## Elevation
               radioButtons('tpSideElevType', 'Elevation:', choices=c('range', 'class'), inline=TRUE),
               conditionalPanel(
                   condition = "input.tpSideElevType == 'range'",
                   sliderInput('tpSideElevRange', 'Elevation Range:',
                               min = tpERange[1], max=tpERange[2], value = tpERange)
               ),
               conditionalPanel(
                   condition = "input.tpSideElevType == 'class'",
                   checkboxGroupInput('tpSideElevClass', 'Elevation Class:',
                                      choices = levels(tpAgg$ELEVCL), selected=levels(tpAgg$ELEVCL), inline=TRUE)
               ))
    ),
    ## TPLOTs
    hr(),
    inlineLabel(
        radioButtons('tpSideShowTPlot', 'Transect Plots:',
                     choices=c('show', 'hide'), inline=TRUE), 5),
    conditionalPanel(
        condition = "input.tpSideShowTPlot == 'show'",
        uiOutput('tpPlotChecks')
    )
)

## Main Panel
tpSubset <- tagList(
    inlineLabel(
        radioButtons('tpSideShow', label='Subset Data:',
                     choices=c('show', 'hide'), inline=TRUE), 5
    ),
    div(id = if (is.null(input$tpSideReset)) "tpA" else paste0("tpA",input$tpSideReset),
        conditionalPanel(
            condition = "input.tpSideShow == 'show'",
            tpSubsetOptions
        ),
        conditionalPanel(
            condition = "input.tpSideShow == 'hide'",
            uiOutput('tpSubsetSummary')
        )),
    hr(style='border:thin solid #1D1A1A;'),
    div(align='center',
        actionButton('tpMake', 'Make Subset', width=100, style='font-size:90%'),
        actionButton('tpSideReset', 'Reset', width=100, style='font-size:90%')),
    hr()
)

