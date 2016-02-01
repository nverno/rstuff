##' @import shiny
NULL

##' Store input values, so when partials are rendered values can be restored
##' 
##' @param prefix UI prefixes
##' @param rvals global reactive values
##' @param input global input
##' @export
captureInputs <- function(prefix, rvals, input) {
  shiny::isolate({
    inps <- grep(sprintf("^%s", prefix), names(input), value=TRUE)
    for (i in inps) rvals[[i]] <- input[[i]]
  })
}

##' Return a list of partials/controllers from subdirectories
##' 
##' @param ids Names of directories to search in
##' @return list of partials and controllers
##' @export
findParts <- function(ids=c("partials", "controllers")) {
  dirs <- list.dirs(recursive=TRUE)
  inds <- setNames(lapply(ids, function(id) basename(dirs) == id), ids)
  lapply(inds, function(ind)
    sub("^\\.+[/\\]+", "",
      list.files(dirs[ind], full.names=TRUE, no..=TRUE)))
}

##' Make dynamic plot containers
##'
##' @param n Number of containers
##' @param ncol Number of columns
##' @param prefix prefix for container name
##' @param height height (css)
##' @param width width (css)
##' @param ... unused
##' @export
makePlotContainers <- function(n, ncol=2, prefix="plot", height=100, width="100%", ...) {
  ## Validate inputs
  validateCssUnit(width)
  validateCssUnit(height)

  ## Construct plotOutputs
  lst <- lapply(seq.int(n), function(i)
    plotOutput(sprintf('%s_%g', prefix, i), height=height, width=width))

  ## Make columns
  lst <- lapply(split(lst, (seq.int(n)-1)%/%ncol), function(x) column(12/ncol, x))
  do.call(tagList, lst)
}

##' Render dynamic plot outputs
##'
##' @param n Number of outpus
##' @param input global input
##' @param output global output
##' @param prefix prefix of plot ids
##' @export
renderPlots <- function(n, input, output, prefix="plot") {
  for (i in seq.int(n)) {
    local({
      ii <- i  # need i evaluated here
      ## These would be your 10 plots instead
      output[[sprintf('%s_%g', prefix, ii)]] <- renderPlot({
        ggplot(dat, aes_string(x='time', y=input$var)) + rndmPlot(input)
      })
    })
  }
}
