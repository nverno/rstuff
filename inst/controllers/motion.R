### motion.R --- 
## Filename: motion.R
## Description: 
## Author: Noah Peart
## Created: Fri Oct 23 06:40:41 2015 (-0400)
## Last-Updated: Fri Oct 23 14:10:12 2015 (-0400)
##           By: Noah Peart
######################################################################
## Prefix: 'goog'

googDat <- reactive({
    samp <- dat()
    if (nrow(samp) < 1) return()
    if (.debug) print('Changed googDat()')
    ## samp$YEAR <- as.Date(samp$YEAR, format="%Y", origin = "1970-01-01")
    samp <- samp[samp$STAT == 'ALIVE' , ]
    samp %>% group_by(SPEC, YEAR, PPLOT) %>%
      summarise(HT = mean(HT, na.rm=TRUE), DBH=mean(DBH, na.rm=TRUE)) -> agg
})

output$googMotion <- renderGvis({
    ## Motion <- gvisMotionChart(googDat(), 
    ##                           idvar="SPEC", 
    ##                           timevar="YEAR",
    ##                           xvar="DBH", yvar="HT")
    ## print(Motion)
    gvisTable(googDat())
})
