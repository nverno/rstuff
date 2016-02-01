### server.R --- 
## Filename: server.R
## Description: Server for shiny app
## Author: Noah Peart
## Created: Tue Oct 20 22:15:39 2015 (-0400)
## Last-Updated: Wed Dec 30 17:24:02 2015 (-0500)
##           By: Noah Peart
######################################################################
## Each partial (UI) should have an associated controller
## An example:
## https://github.com/jcheng5/shiny-partials/blob/master/server.R

## Data
source("R/setup.R", chdir=TRUE)
pp$key <- seq_len(nrow(pp))
tp$key <- seq_len(nrow(tp))

## Transect summaries: this should be available everywhere
tpAgg <- aggregate(TPLOT ~ TRAN + ELEV + ELEVCL + ASP + ASPCL + YEAR, FUN=unique, data=tp)
tpAgg <- with(tpAgg, tpAgg[order(TRAN, TPLOT, YEAR), ])

## Transect summaries: this should be available everywhere
ppAgg <- aggregate(PPLOT ~ ELEV + ELEVCL + ASP + ASPCL + YEAR + SOILCL, FUN=unique, data=pp)
ppAgg <- with(ppAgg, ppAgg[order(PPLOT, YEAR), ])

shinyServer(
    function(input, output, session) {
        ## Find all controllers and interfaces
        values <- reactiveValues()
        values$sources <- findParts(ids=c("partials", "controllers"))

        ## source the controllers
        for (file in isolate(values$sources$controllers)) source(file, local=TRUE)
        
        output$container <- renderUI({
            if (is.null(input$partial))
                return( NULL )
            
            ## Any security checks for bad paths
            ## Add path to reactiveValues as well
            if (input$partial %in% usePlot)
                source("partials/plotting_ui.R", local=TRUE)

            fname <- paste0(input$partial, "_ui")
            projectPath <- file.path("partials")

            if (input$partial == 'ggvis') {
                projectPath <- file.path("ggvis", "brush-linked", "partials")
                fname <- "brushes"
            } 

            values$projectPath <- projectPath

            ## Sources from projectPath/partials/<page>.R
            source(file.path(projectPath, paste0(fname, ".R")), local=TRUE)$value
        })
    }
)
