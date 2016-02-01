### brushes.R --- 
## Filename: brushes.R
## Description: 
## Author: Noah Peart
## Created: Tue Oct 20 22:03:07 2015 (-0400)
## Last-Updated: Wed Oct 21 22:05:39 2015 (-0400)
##           By: Noah Peart
######################################################################
library(ggvis)

## ## Input: cant source input from ggvis?
## lb <- linked_brush(keys = cocaine$id, "red")
bootstrapPage(
    ## ggvisOutput('linked1'),
    ## ggvisOutput('linked2'),
    ggvisOutput('brush1'),
    h3('Summary of brushed data'),
    verbatimTextOutput('brush_data')
)
