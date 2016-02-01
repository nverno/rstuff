### difference_chart.R --- 
## Filename: difference_chart.R
## Description: 
## Author: Noah Peart
## Created: Mon Feb  1 15:16:45 2016 (-0500)
## Last-Updated: Mon Feb  1 15:17:13 2016 (-0500)
##           By: Noah Peart
######################################################################
## Can be a useful alternative to side-by-side barcharts.
## The middle line for each group represents the average across all
## groups.

## Example with iris data: look at the difference from the mean
## for each species for each variable
library(data.table)
dat <- as.data.table(iris)
mus <- melt(dat[, lapply(.SD, mean), by=Species], id.vars="Species")

## Barplot versions
library(ggplot2)
library(gridExtra)
p1 <- ggplot(mus, aes(Species, value, fill=variable)) +
    geom_bar(stat='identity', position='dodge')
p2 <- ggplot(mus, aes(Species, value, fill=variable)) +
    geom_bar(stat='identity', position='stack')
grid.arrange(p1, p2)

################################################################################
##
##                         Difference chart version
##
################################################################################
## Sweep out grand means
sdcols <- names(dat)[names(dat) != "Species"]
dt <- dat[, lapply(.SD, function(x) x-mean(x)), .SDcols=sdcols][
  , Species := dat$Species][
  , lapply(.SD, mean), by=Species]
dt <- melt(dt, id.vars = "Species")

## https://github.com/jalapic/shinyapps/blob/master/golf/server.R
brks <- round(max(abs(dt$value)), 2) * c(-1, 0, 1)
ggplot(dt, aes(value, variable)) +
    geom_segment(aes(x=value, xend=0, y=variable, yend=variable), color='black', lwd=6) +
    geom_vline(xintercept=0) +
    ## scale_x_continuous(breaks=brks, labels=paste(brks)) +
    facet_grid(~Species) +
    xlab('') + ylab('') +
    xlim(range(brks)) +
    theme(
        plot.title = element_text(hjust=0, vjust=1, size=rel(2.3)),
        plot.background = element_blank(),
        strip.background = element_blank(),
        panel.background = element_blank(),
        panel.grid.major.x = element_line(color='gray70', linetype='28'),
        panel.grid.major.y = element_line(color='gray86'),
        strip.text = element_text(size=rel(1.8)),
        text = element_text(color='gray20', size=10),
        axis.text = element_text(size=rel(1.0)),
        axis.text.x = element_text(color='gray20', size=rel(1.6)),
        axis.text.y = element_text(color='gray20', size=rel(1.6)),
        axis.title.x = element_text(size=rel(1.8), vjust=0),
        axis.title.y = element_text(size=rel(1.8), vjust=1),
        legend.position = 'none',
        panel.margin = unit(2, 'lines')
    )
