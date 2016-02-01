### leaflet_layers.R --- 
## Filename: leaflet_layers.R
## Description: Generic leaflet controller - nothing to do with actual data
## Author: Noah Peart
## Created: Sat Oct 31 13:31:10 2015 (-0400)
## Last-Updated: Sat Oct 31 13:37:21 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'leaf'

leafVals <- reactiveValues(
    ## Default layer
    leafLayerDefault="Esri.WorldTopoMap",
    ## Various map layers
    leafTerrain=c(
        "Topo1"="Esri.WorldTopoMap",
        "Basic"="Basic",
        "Satellite1"="MapQuestOpen.Aerial",
        "Satellite2"="Esri.WorldImagery",
        "Topo2"="OpenTopoMap",
        "Terrain"="Esri.WorldTerrain",
        "Terrain2"="Acetate.terrain",
        "Physical"="Esri.WorldPhysical",
        "Hill-shaded"="Acetate.hillshading",
        "Watercolor"="Stamen.Watercolor"
    ),
    leafWeather=c(
        "None"="None",
        "Precipitation"="OWM.Precipitation",
        "Pressure"="OpenWeatherMap.Pressure",
        "Pressure-Contour"="OpenWeatherMap.PressureContour",
        "Wind"="OpenWeatherMap.Wind",
        "Temperature"="OpenWeatherMap.Temperature",
        "Snow"="OpenWeatherMap.Snow"
    ),
    ## Map layers to add distinction to roads/trails
    leafToners=c(
        "None"="None",
        "Light"="Stamen.TonerLite",
        "Dark"="Stamen.Toner",
        "Toner-lines"="Stamen.TonerLines",
        "Toner-labels"="Stamen.TonerLabels"
    )
)

################################################################################
##
##                       Observers for various layers
##
################################################################################
## Add/remove Base Layers: group 'provider'
observeEvent(input$leafTerrain, {
    inps <- nonEmpty(list(terrain=input$leafTerrain))
    if (.debug) print(paste('Layer:', inps$terrain))
    opacity <- if (input$leafBaseOverlay) input$leafBaseOverlayOpacity else 1

    if (inps$terrain == 'Basic') {
        leafletProxy('leafMap') %>%
          addTiles(group='basic')
    } else if (!is.null(inps$terrain)) {
        if (.debug) print(sprintf('Adding %s', inps$terrain))
        leafletProxy("leafMap") %>%
          showGroup('provider') %>%
          addProviderTiles(inps$terrain, group='provider',
                           options = providerTileOptions(opacity = opacity))
    }
})

## Toner layers: group 'toner'
observeEvent(input$leafToner, {
    inps <- nonEmpty(list(toner=input$leafToner))
    opacity <- if (input$leafBaseOverlay) input$leafBaseOverlayOpacity else 1
    if (.debug) print(paste('Toner:', inps$toner))
    
    if (inps$toner == 'None') {
        leafletProxy('leafMap') %>%
          hideGroup('toner')
    } else {
        leafletProxy("leafMap") %>%
          showGroup('toner') %>%
          addProviderTiles(inps$toner, group='toner',
                           options = providerTileOptions(opacity = opacity))
    }
})

## Weather layers: group 'weather'
observeEvent(input$leafWeather, {
    inps <- nonEmpty(list(weather=input$leafWeather))
    opacity <- if (input$leafBaseOverlay) input$leafBaseOverlayOpacity else 1
    if (.debug) print(paste('Weather:', inps$weather))
    
    if (inps$weather == 'None') {
        leafletProxy('leafMap') %>%
          hideGroup('weather')
    } else {
        leafletProxy("leafMap") %>%
          showGroup('weather') %>%
          addProviderTiles(inps$weather, group='weather',
                           options = providerTileOptions(opacity = opacity))
    }
})

## Reset layers
observeEvent(input$leafLayerReset, {
    leafletProxy('leafMap') %>%
      clearGroup('provider') %>%
      clearGroup('toner') %>%
      clearGroup('weather') %>%
      clearGroup('basic') %>%
      showGroup('default')
    updateSelectizeInput(session, 'leafTerrain', selected=isolate(leafVals$leafLayerDefault))
    updateSelectizeInput(session, 'leafToner', selected='None')
    updateSelectizeInput(session, 'leafWeather', selected='None')
    updateCheckboxInput(session, 'leafBaseOverlay', value=FALSE)
})
