### server.R --- 
## Filename: server.R
## Description: 
## Author: Noah Peart
## Created: Mon Oct 26 14:17:05 2015 (-0400)
## Last-Updated: Mon Oct 26 17:10:11 2015 (-0400)
##           By: Noah Peart
######################################################################

library(shiny)
library(ggvis)


shinyServer(function(input,output,session){   

    dataInput = reactive({
        gg = df[which(df$Student == input$stu),]
    })

    buffer <- 3.5  # set to make the rectangle reach the scale boundaries
    rectLims <- list(lower=c(40-buffer, 80), upper=c(50, 120+buffer))
    make_rect <- function(vis, lims, buffer=buffer, ...) {
        for (i in seq_along(lims$lower))
            vis <- layer_rects(vis, x = ~min(year), x2 =~max(year),
                               y = rectLims$lower[i], y2 = rectLims$upper[i],
                               fill := "blue", opacity := 0.05)
        vis
    }

    vis = reactive({
        data = dataInput()
        ## inrange <- with(dataInput(), dataInput()[score >=80 | score <= 50,])
        inrange <- +with(data, score >=80 | score <= 50)
        
        data %>%
          ggvis(x = ~year, y = ~score) %>%
          scale_numeric("y",domain = c(40,120)) %>%
          layer_points(opacity = ~inrange) %>%
          layer_lines() %>%
          make_rect(lims=rectLims)
    })

    vis %>% bind_shiny("plot")
})
