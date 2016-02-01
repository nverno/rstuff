### ui.R --- 
## Filename: ui.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 22:10:44 2015 (-0400)
## Last-Updated: Tue Nov  3 08:14:30 2015 (-0500)
##           By: Noah Peart
######################################################################

fluidPage(
    theme=shinytheme("flatly"),
    tags$head(tags$link(
        rel="stylesheet", type="text/css", href="styles.css"
        
    ), tags$title("Moosilauke Data")),
    includeScript("www/scripts.js"),

    ## Conditional panels to render partial interfaces
    navbarPage(
        title="Moosilauke Data",
        id = 'partial',
        tabPanel('Todo', value='todo'),
        navbarMenu(
            title="Maps",
            tabPanel('Interactive (leaflet)', value='leaflet'),
            tabPanel('Static (google)', value='map')
        ),
        navbarMenu(
            title="Data",
            tabPanel('Selection', icon=shiny::icon('database'), value="subset"),
            tabPanel('Table', icon=shiny::icon('table'), value = 'dataTable'),
            tabPanel('Aggregate', value='aggregate')
        ),
        navbarMenu(
            title = '',
            icon = shiny::icon('bar-chart'),
            tabPanel('Barplot', icon=shiny::icon('bar-chart'), value="barplot"),
            tabPanel('Scatterplot', icon=shiny::icon('line-chart'), value='scatter'),
            tabPanel('Motion', value='motion', icon = shiny::icon('wrench')),
            tabPanel('GGvis', value="ggvis", icon = shiny::icon('wrench'))
        ),
        navbarMenu(
            title="",
            icon = shiny::icon('info-circle'),
            tabPanel('Data Info', value='info')
        ),
        tabPanel(title="", value='code', icon = shiny::icon('code'))
    ),
    
    uiOutput("container"),

    ## Debug info
    lapply(1:4, function(i) br()),
    if (.debug) source("partials/debug_ui.R", local=TRUE)$value
)
