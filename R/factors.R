##' Create factor levels in a standard way
##'
##' If the underlying variable is numeric, like PPLOT,
##' orders the factor numerically, otherwise uses a standard sort
##'
##' @title Level ordering
##' @param v Variable to convert to factor
##' @param include.empty If specified, include empty strings as factors
##' @param empty If \code{include.empty} is true, specifies location of empty level.
##' @return Vector containing order of levels.
##' @export
levOrder <- function(v, include.empty=TRUE, empty=c('back', 'front')) {
    if (is.factor(v)) v <- as.character(v)
    res <- if (any(stringi::stri_detect(v, regex="[[:alpha:]]"), na.rm=TRUE)) 
        sort(unique(na.omit(v)))
    else sort(unique(as.numeric(as.character(v))))
    res <- res[nzchar(res)]
    if (include.empty)
        res <- if (match.arg(empty) == 'back') c(res, '') else c('', res)
    res
}

##' Make factors from data column
##'
##' I don't think I ever use this?  Since data.tables store characters 
##' just as efficiently with the string cache...
##'
##' @param col Column
##' @param data Data
##' @param drop Drop NAs
##' @export
make_factor <- function(col, data, drop=TRUE) {
  ord <- levOrder(data[[col]])

  if (inherits(data, 'data.table')) {
    data[, get(col) := factor(get(col), levels=ord)]
    # if (drop) data[, get('col') := droplevels(get('col'))]
    return( invisible() )
  } else 
    data[[col]] <- factor(data[[col]], levels=ord)
  data
}
