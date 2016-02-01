### global.R --- 
## Filename: global.R
## Description: 
## Author: Noah Peart
## Created: Mon Oct 26 14:19:59 2015 (-0400)
## Last-Updated: Mon Oct 26 14:20:34 2015 (-0400)
##           By: Noah Peart
######################################################################

df <- data.frame(Student = c("a","a","a","a","a","b","b","b","b","b","c","c","c","c"),
                 year = c(seq(2001,2005,1),seq(2010,2014,1),seq(2012,2015,1)),
                 score = runif(14,min = 50,max = 100), stringsAsFactors=F)

library(ggvis)
library(shiny)
