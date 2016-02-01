df <- read.table(text="   income expense education gender residence
1   153      2989 NoCollege      F       Own
2   289       872   College      F      Rent
3   551        98 NoCollege      M      Rent
4   286       320   College      M      Rent
5   259       372 NoCollege      M      Rent
6   631       221 NoCollege      M       Own
7   729       105   College      M      Rent
8   582       450 NoCollege      M       Own
9   570       253   College      F      Rent
10 1380       635 NoCollege      F      Rent
11  409       425 NoCollege      M      Rent
12  569       232 NoCollege      F       Own
13  317       856   College      M      Rent
14  199       283   College      F       Own
15  624       564 NoCollege      M       Own
16 1064       504 NoCollege      M       Own
17  821       169 NoCollege      F      Rent
18  402       175   College      M       Own
19  602       285   College      M      Rent
20  433       264   College      M      Rent
21  670       985 NoCollege      F       Own", header=TRUE)

library(treemap)
library(data.table)

## Some dummy variables to aggregate by: ALL, i, and index
dat <- as.data.table(df)[, `:=`(total = factor("ALL"), i = 1, index = 1:.N)][]
indexList <- c('total', 'gender', 'education', 'residence')  # order or aggregation

## Function to aggregate at each grouping level (SIR)
agg <- function(index, ...) {
    dots <- list(...)
    expense <- dots[["expense"]][index]
    income <- dots[["income"]][index]
    sum(expense) / sum(income) * 100
}

## Get treemap data
res <- treemap(dat, index=indexList, vSize='i', vColor='index',
               type="value", fun.aggregate = "agg",
               palette = 'RdYlBu',
               income=dat[["income"]],
               expense=dat[["expense"]])  # ... args get passed to fun.aggregate

## Now use ggplot to make the bargraph
## The useful variables: level (corresponds to indexList), vSize (bar size), vColor(SIR)
## Create a label variable that is the value of the variable in indexList at each level
out <- res$tm
out$label <- out[cbind(1:nrow(out), out$level)]
out$label <- with(out, ifelse(level==4, substring(label, 1, 1), label))  # shorten labels
out$level <- factor(out$level, levels=sort(unique(out$level), TRUE))     # factor levels

## Time to find label positions, scale to [0, 1] first
## x-value is cumsum by group,  y will just be the level
out$xlab <- out$vSize / max(aggregate(vSize ~ level, data=out, sum)$vSize)
split(out$xlab, out$level) <- lapply(split(out$xlab, out$level), function(x) cumsum(x) - x/2)

## Make plot with gradient color for SIR
library(ggplot2)
ggplot(out, aes(x=level, y=vSize, fill=vColor, group=interaction(level, label))) +
  geom_bar(stat='identity', position='fill') +  # add another for black rectangles but not legend
  geom_bar(stat='identity', position='fill', color="black", show_guide=FALSE) +
  geom_text(data=out, aes(x=level, y=xlab, label=label, ymin=0, ymax=1), size=6, font=2,
            inherit.aes=FALSE) +
  coord_flip() +
  scale_fill_gradientn(colours = c("white", "red")) +
  theme_minimal() +  # Then just some formatting 
  xlab("") + ylab("") +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
