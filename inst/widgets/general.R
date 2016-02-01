## Spaces between buttons in input panel
buttonSeparator <- hr(style="margin-top: 0.2em; margin-bottom: 0.2em;")

## Make options appear inline with label
inlineLabel <- function(widget, sep)
    gsub("class=\"shiny-options-group\"",
         sprintf("style=\"display:inline;margin-left:%spx\"", sep), widget)

## https://github.com/ua-snap/shiny-apps/blob/master/plot3D/ui.R
headerPanel <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
      h(title)
    )
}
