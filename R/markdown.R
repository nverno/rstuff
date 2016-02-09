### markdown.R --- 
## Filename: markdown.R
## Description: Functions to help with markdown related tasks
## Author: Noah Peart
## Created: Mon Feb  8 23:31:20 2016 (-0500)
## Last-Updated: Mon Feb  8 23:58:30 2016 (-0500)
##           By: Noah Peart
######################################################################

##' Make nice for markdown
##' 
##' @param x input vector
##' @param type 'each' wraps each element in ``, 'all' wraps the whole vector in ``
##' @export
prettify <- function(x, type=c('each', 'all')) {
  tt <- match.arg(type, c('each', 'all'))
  if (tt == 'each') {
    gsub('([[:alnum:]]+)', '`\\1`', toString(x))
  } else if (tt == 'all') {
    sprintf('`%s`', toString(x))
  }
}

##' Render and browse the file
##' 
##' @param file File name
##' @param format Optional output format
##' @export
see <- function(file, format) {
  if (!requireNamespace("rmarkdown")) {
    warning("this requires rmarkdown package")
    return(invisible())
  }
  if (!file.exists(file)) stop('Cant find file')
  out <- if (missing(format)) {
    rmarkdown::render(file)
  } else rmarkdown::render(file, output_format=format)
  browseURL(out)
}


