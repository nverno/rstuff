### leaflet_ui.R --- 
## Filename: leaflet_ui.R
## Description: 
## Author: Noah Peart
## Created: Wed Oct 28 15:59:57 2015 (-0400)
## Last-Updated: Tue Nov  3 00:24:31 2015 (-0500)
##           By: Noah Peart
######################################################################
## Prefix: 'leaf'

## Map layers
leafLayers <- tagList(
    fluidRow(
        id='leaf-layers', class='leaf-controls collapse',
        checkboxInput('leafBaseOverlay', 'Overlay Maps', FALSE),
        conditionalPanel(
            condition='input.leafBaseOverlay==true',
            sliderInput('leafBaseOverlayOpacity', 'Opacity', min=0, max=1, value=0.35)
        ),
        selectizeInput('leafTerrain', 'Base Layers', choices=isolate(leafVals$leafTerrain),
                       selected=isolate(leafVals$leafLayerDefault)),
        selectizeInput('leafToner', 'Toner Layers',
                       choices=isolate(leafVals$leafToners), selected=NULL),
        selectizeInput('leafWeather', 'Weather Layers',
                       choices=isolate(leafVals$leafWeather), selected=NULL),
        actionButton('leafLayerReset', 'Reset Layers', style='height:10%;'),
        hr(style="height:1px;padding:0px")
    )
)

## Inputs for variables to be shown on map
aggChoices <- names(isolate(pploc))[grepl("CL$", names(isolate(pploc)))]
leafVariable <- tagList(
    fluidRow(
        id='leaf-variable', class='leaf-controls collapse',
        selectInput('leafAggVar', 'Summary Variable', choices=c('None', aggChoices)),
        selectInput('leafColor', 'Color Scheme',
                    choices=rownames(brewer.pal.info[brewer.pal.info %in% c("seq", "div")])),
        checkboxInput('leafLegend', 'Legend', TRUE),
        hr()
    )
)

## Create some buttons to expand options
leafExpanders <- tagList(
        tags$button(
            href="#leaf-control-panel", `data-toggle`="collapse",
            `data-target`="#leaf-layers", class="btn-info",
            span('Layers', style='color:black; margin:auto;')),
        tags$button(
            href="#leaf-control-panel", `data-toggle`="collapse",
            `data-target`="#leaf-variable", class='btn-info',
            span('Variable', style='color:black'))
)

## Location markesr
leafLocations <- tagList(
    div(style='font-size:90%',
        radioButtons('leafPPMarks', 'Permanent Plots',
                     choices=c('Cluster'='clusters', 'Pins'='markers', 'Hide'='hide'), inline=TRUE),
        radioButtons('leafTPMarks', 'Transects',
                     choices=c('Cluster'='clusters', 'Pins'='markers', 'Hide'='hide'), inline=TRUE,
                     selected = 'hide'),
        radioButtons('leafContMarks', 'Contours',
                     choices=c('Cluster'='clusters', 'Pins'='markers', 'Hide'='hide'), inline=TRUE,
                     selected='hide'),
        radioButtons('leafOtherMarks', 'Other',
                     choices=c('Cluster'='clusters', 'Pins'='markers','Hide'='hide'), inline=TRUE,
                     selected='hide'),
        hr()
        )
)

leafOpts <- tagList(
    fluidRow(
        class='leaf-controls', id="leaf-options",
        leafExpanders,
        leafLayers,
        leafVariable,
        leafLocations
    )
)

## Main output: map covers entire page
bootstrapPage(
    leafletOutput('leafMap', width="100%", height=800),
    div(class = "leaf-control-panel",
        a(href="#leaf-control-panel", class='leaf-toggle', role='button',
          `data-toggle`='collapse', `data-target`="#leaf-options",
          span(class="sr-only", "Toggle Leaf Controls"),
          shiny::icon("bars", "fa-wide")),

        ## Selectors
        leafOpts
        )
)
