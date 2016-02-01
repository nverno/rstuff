### leaflet.R --- 
## Filename: leaflet.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 28 14:04:33 2015 (-0400)
## Last-Updated: Tue Nov  3 00:50:48 2015 (-0500)
##           By: Noah Peart
######################################################################
## Prefix: 'leaf'

## Group naming conventions
## dataset prefixes/postfix, 'pp' = permanent plots, 'tp' = transects
leafPrefix <- c('pp'='pp', 'tp'='tp', 'contour'='cont', 'other'='other')

## Feature names for groups
leafFeature <- list(markers=list(markers='Marks', clusters='MarksClustered'))

## Store current groups/marks: havent figured out how to get this from map
## Initialize with all markers/clusters
leafInit <- leafPrefix[c('pp', 'tp', 'contour', 'other')]
leafMarks <- reactiveValues(groups=NULL)

## zIndex not implemented..
leafLabelOpts <- labelOptions(clickable = TRUE)  # zIndex = 1

## Make some icons for the different markers
icon.pp <- makeAwesomeIcon(icon = 'flag', markerColor = 'blue',
                           iconColor = 'black', library = 'fa')
icon.tp <- makeAwesomeIcon(icon = 'flag', markerColor = 'orange',
                           iconColor = 'black', library = 'fa')
icon.cont <- makeAwesomeIcon(icon = 'flag', markerColor = 'green',
                           iconColor = 'black', library = 'fa')

################################################################################
##
##                                 Functions
##
################################################################################
## Coloring aggregating variables (shapes)
## https://rstudio.github.io/leaflet/shiny.html
colorpal <- function(colors, variable) {
    colorFn <- switch(class(variable),
                      "factor"  = colorFactor,
                      "numeric" = colorNumeric,
                      function(...)warning("No color function implemented for that type."))
    colorFn(colors, variable)
}

## Show/Hide/Add a grouped feature
leafManip <- function(data, feature, choice) {
    proxy <- leafletProxy('leafMap')

    ## Hide groups if any
    if (choice=='hide') {
        groups <- paste0(data, leafFeature[[feature]])
        for (group in groups) proxy %>% hideGroup(group)
        return()
    }

    ## Show groups
    inds <- names(leafFeature[[feature]]) == choice
    if (sum(inds) == 0) return()
    show <- paste0(data, unlist(leafFeature[[feature]][inds]))
    if (!(show %in% isolate(leafMarks$groups)))
        leafCreate(data, feature, choice)
    proxy %>% showGroup(show)

    ## Hide other mutually exclusive groups
    if (sum(!inds) == 0) return()
    hide <- paste0(data, unlist(leafFeature[[feature]][!inds]))
    proxy %>% hideGroup(hide)
}

## Add/update a map with a new feature
leafCreate <- function(data, feature, choice, map=NULL, mapName='leafMap') {
    proxy <- if(!missing(map)) map else leafletProxy(mapName)
    dat <- switch(data, 'pp'=pploc, 'tp'=tploc, 'cont'=contloc, 'other'=otherloc)
    icon <- switch(data, 'pp'=icon.pp, 'tp'=icon.tp, 'cont'=icon.cont, 'other'=NULL)

    ## Adding markers
    if (feature == 'markers') {
        group <- paste0(data, leafFeature[[feature]][choice])
        if (.debug) print(sprintf('Created markers for %s', group))
        leafMarks$groups <- c(isolate(leafMarks$groups), group)
        
        if (choice == 'clusters')
            proxy %>%
              addMarkers(data=dat, lng=~lng, lat=~lat, clusterOptions = markerClusterOptions(),
                         group=group, label=~lapply(get(paste0(data,'Lab')), HTML),
                         labelOptions = leafLabelOpts,
                         layerId = ~paste0(data,'C', id)) -> res
        if (choice == 'markers')
            proxy %>%
              addAwesomeMarkers(data=dat, lng=~lng, lat=~lat, labelOptions=leafLabelOpts,
                                layerId = ~paste0(data, id), icon=icon,
                                group=group,
                                label=~lapply(get(paste0(data,'Lab')), HTML)) -> res
    }
    if (!missing(map)) return( res )
}

################################################################################
##
##                                 Reactives
##
################################################################################
## Non of the location data is currently reactive

################################################################################
##
##                                Observers
##
################################################################################
## Markers
observeEvent(input$leafPPMarks, leafManip('pp', feature='markers', choice=input$leafPPMarks))
observeEvent(input$leafTPMarks, leafManip('tp', feature='markers', choice=input$leafTPMarks))
observeEvent(input$leafContMarks, leafManip('cont', feature='markers', choice=input$leafContMarks))
observeEvent(input$leafOtherMarks, leafManip('other', feature='markers', choice=input$leafOtherMarks))

################################################################################
##
##                          Observers for Variables
##
################################################################################
## Change circle color in response to leafAggVar
## observe({
##     inps <- nonEmpty(list(agg   = input$leafAggVar,
##                           color = input$leafColor))
##     if (!length(inps)) return()

##     isolate({
##         if (.debug) print('Aggregation Variable')
##         proxy <- leafletProxy('leafMap', data=leafDat())
##         proxy %>% clearGroup('ppCircles') %>% removeControl('ppLegend')

##         if (inps$agg != 'None') {
##             agg <- leafDat()[[inps$agg]]
##             pal <- colorpal(inps$color, agg)
##             proxy %>%
##               addCircles(lng=~lng, lat=~lat, radius=80,
##                          color = '#777777', fillColor = ~pal(agg),
##                          fillOpacity = 0.7, popup = ~paste(agg),
##                          group='ppCircles')
##         }
##     })
## })

## observeEvent(input$leafLegend, {
##     proxy <- leafletProxy('leafMap', data=leafDat())
##     proxy %>% clearControls()
##     if (input$leafLegend && input$leafAggVar != 'None') {
##         agg <- leafDat()[[input$leafAggVar]]
##         pal <- colorpal(input$leafColor, agg)
##         proxy %>%
##           addLegend(position="bottomright", pal=pal, values= ~agg,
##                     title=input$leafAggVar, layerId = 'ppLegend')
##     }
## })

################################################################################
##
##                             Starter Map
##
################################################################################
## Initially render parts of map that change the least
output$leafMap <- renderLeaflet({
    ## Leaflet will guess the correct columns, but might as well be explicit
    if (.debug) print("Rendered leafMap")
    
    leaflet() %>%
      addProviderTiles("Esri.WorldTopoMap", group='default') %>%
      ## Center on moosilauke
      fitBounds(lng1=mooseView[['lng1']], lat1=mooseView[['lat1']],
                lng2=mooseView[['lng2']], lat2=mooseView[['lat2']]) -> map

    for (dat in leafInit) {
        map <- leafCreate(dat, 'markers', 'markers', map=map) %>%      # add markers
          leafCreate(dat, 'markers', 'clusters', map=.) %>%            # add clusters
          hideGroup(paste0(dat, leafFeature$markers$markers)) %>%      # hide markers
          hideGroup(paste0(dat, leafFeature$markers$clusters))         # hide clusters
      }

    ## Show only clustered permanent plots to start
    map %>% showGroup('ppMarksClustered')
})
