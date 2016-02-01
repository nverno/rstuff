## ui.R
library(ggvis)
library(shiny)

ui <- shinyUI(fluidRow(
  uiOutput('ui_plot1'),
  ggvisOutput("graph_plot1")
))

## server.R
server <- shinyServer(function(input, output, session) {
  domains <- reactiveValues(x = c(NA, NA), y = c(NA, NA))

  observe({
      domains$x
      print(domains$x)
  })
  
  zoom_brush = function(items, session, page_loc, plot_loc, ...) {
    domains$x = c(page_loc$l - plot_loc$l, page_loc$r - plot_loc$r)
  }

  plot = reactive({
      domains$x
    mtcars %>% 
      ggvis(~disp, ~mpg) %>%
      layer_points() %>%
      scale_numeric('x', domain = domains$x, clamp = TRUE) %>% 
      handle_brush(zoom_brush)
  }) %>% bind_shiny('graph_plot1', 'ui_plot1')
})

shinyApp(ui, server)
