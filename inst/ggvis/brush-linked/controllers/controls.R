### controls.R --- 
## Filename: controls.R
## Description: Examples with brush and ggvis
## Author: Noah Peart
## Created: Tue Oct 20 21:58:02 2015 (-0400)
## Last-Updated: Thu Oct 22 19:57:10 2015 (-0400)
##           By: Noah Peart
######################################################################
require(ggvis)

## Load some data
## cocaine <- cocaine[sample(1:nrow(cocaine), 500),]
## cocaine$id <- seq_len(nrow(cocaine))

## Input
## tp$key <- seq_len(nrow(tp))
## tpDat <- reactive({ tp })

## lb <- reactive({ linked_brush(keys = tpDat()$key, "red") })

## ## Plot1
## tpDat %>%
##   ggvis(~DBH, ~HT, key := ~key) %>%
##   layer_points(fill := isolate(lb())$fill, fill.brush := 'red', opacity := 0.3) %>%
##   isolate(lb())$input() %>%  # the brush input
##   set_options(width = 300, height = 300) %>%
##   bind_shiny('linked1')

## ## Subset of the selected components
## dat_selected <- reactive({
##     selected <- lb()$selected
##     tpDat()[selected(),]
## })

## ## Plot2
## tpDat %>%
##   ggvis(~BV) %>%
##   layer_histograms(width = 5, boundary = 0) %>%
##   add_data(dat_selected %>%
##   layer_histograms(width = 5, boundary = 0, fill := "#dd3333") %>%
##   set_options(width = 300, height = 300) %>%
##   bind_shiny('linked2')

lb <- mylinked_brush(keys=NULL, "red")

selected <- lb$selected
dat_selected <- reactive({
    if (.debug) print('Created dat_selected')
    if (!any(selected())) return( dat() )
    dat()[selected(), ]
})

dat %>%
  ggvis(~DBH, ~HT) %>%
  layer_points(fill := lb$fill, fill.brush := "red") %>%
  lb$input() %>%
  add_data(dat_selected) %>%
  layer_model_predictions(model = "lm") %>%
  bind_shiny('brush1')

output$brush_data <- renderPrint({
    cat("Number of points selected: ", nrow(dat_selected()), "\n\n")
    print(summary(dat_selected()))
})

