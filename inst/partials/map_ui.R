### map_ui.R --- 
## Filename: map_ui.R
## Description: 
## Author: Noah Peart
## Created: Fri Oct 23 06:15:40 2015 (-0400)
## Last-Updated: Tue Oct 27 20:54:43 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'map'

mapOpts <- tagList(
    fluidRow(
        column(4,
               helpText("Enter location like in Google maps."),
               textInput('mapPlaceName', "Location Name:",
                            value= mapVals$mapPlaceName %||% "Mt Moosilauke"),
               actionButton('mapGet', 'Get it!')),
        column(4, 
               helpText("Zoom determines the scale of the map (higher value = more zoom)."),
               numericInput('mapZoom', "Zoom", min=0, value= mapVals$mapZoom %||% 14)),
        column(4,
               helpText('Some options can take some time or fail altogether.'),
               selectInput('mapType', 'Map Type',
                           choices = c("terrain", "terrain-background", "satellite",
                               "roadmap", "hybrid", "toner", "watercolor", "terrain-labels", "terrain-lines",
                               "toner-2010", "toner-2011", "toner-background", "toner-hybrid",
                               "toner-labels", "toner-lines", "toner-lite"),
                           selected = mapVals$mapType %||% "terrain"))
    ),
    checkboxInput('mapUseMarkers', 'Use Plot Locations')
)

fluidPage(
    wellPanel(
            mapOpts 
    ),
    plotOutput('map_static', height="600px")
)
