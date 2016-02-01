### subset_permanent_ui.R --- 
## Filename: subset_permanent_ui.R
## Description: 
## Author: Noah Peart
## Created: Thu Oct 22 16:45:50 2015 (-0400)
## Last-Updated: Sat Oct 31 15:07:38 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'pp'

## Globals:
## Permanent plot data: 'pp'
## Aggregated summary is 'ppAgg'
ppERange <- range(ppAgg$ELEV, na.rm=TRUE)

## Main permanent plot subsetting options
ppSubsetOptions <- tagList(
    fluidRow(
        column(3,
               ## Plot number
               checkboxGroupInput('ppPlot', "Plot:", choices=levels(ppAgg$PPLOT), inline=TRUE),
               fluidRow(
                   actionButton('ppAllPlots', "Select All"),
                   actionButton('ppNonePlots', "Deselect All")
               )),
        column(4, class='col-sm-4 verticalLine',
               helpText("Use the following selectors to subset available plots."),
               
               ## Aspect
               checkboxGroupInput('ppAsp', 'Aspect:',
                                  choices = levels(ppAgg$ASPCL),
                                  selected = levels(ppAgg$ASPCL), inline=TRUE),

               ## Soil Class
               checkboxGroupInput('ppSoilClass',  'Soil Class:',
                                  choices = levels(ppAgg$SOILCL),
                                  selected= levels(ppAgg$SOILCL), inline=TRUE),
               
               ## Elevation
               radioButtons('ppElevType', 'Elevation:', choices=c('range', 'class'), inline=TRUE),
               conditionalPanel(
                   condition = "input.ppElevType == 'range'",
                   sliderInput('ppElevRange', 'Elevation Range:',
                               min = ppERange[1], max=ppERange[2],
                               value = ppERange)
               ),
               conditionalPanel(
                   condition = "input.ppElevType == 'class'",
                   checkboxGroupInput('ppElevClass', 'Elevation Class:',
                                      choices = levels(ppAgg$ELEVCL),
                                      selected= levels(ppAgg$ELEVCL), inline=TRUE)
               )),
        column(5, class='col-sm-5 verticalLine',
               h4("Summary"),
               helpText("Initially all the data is selected.", style='font-size:75%;'),
               hr(),
               uiOutput('ppSubsetSummary'))
    )
)

## Main Panel
ppSubset <- tagList(
    ## Wrap subset options in a div that changes with reset
    div(id = if (is.null(input$ppReset)) "ppA" else paste0("ppA",input$ppReset),
        ppSubsetOptions),
    hr(style='border:thin solid #1D1A1A;'),
    div(align='center',
        actionButton('ppMake', 'Make Subset', width=100, style='font-size:90%'),
        actionButton('ppReset', 'Reset Options', width=110, style='font-size:90%')),
    hr()
)
