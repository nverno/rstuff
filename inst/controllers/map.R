### map.R --- 
## Filename: map.R
## Description: Pull moose map of google maps
## Author: Noah Peart
## Created: Fri Oct 23 06:14:34 2015 (-0400)
## Last-Updated: Wed Oct 28 14:46:57 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'map'
mapVals <- reactiveValues(mapDat=NULL)

observeEvent(input$mapGet, {
    if (.debug) print("Changed mapVals")
    name <- input$mapPlaceName
    loc <- as.numeric(geocode(name))
    if (is.na(sum(loc))) return()
    mapVals$mapDat <- if (input$mapUseMarkers) {
        get_googlemap(center = loc, zoom = input$mapZoom, maptype=input$mapType,
                      markers=ppmarks)
    } else
        get_map(loc, zoom=input$mapZoom, maptype=input$mapType)
    captureInputs('map', mapVals, session$input)
})

output$map_static <- renderPlot({
    input$mapGet
    if (!is.null(mapVals$mapDat))
        ggmap(mapVals$mapDat)
    ## plot(gvisMap(data.frame(LatLong='44.0245:71.8309', tip="Mt Moosilauke")))
})

