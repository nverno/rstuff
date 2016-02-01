##' Grep indices ordered by year
##' 
##' @param coln Columns
##' @param yrs Years
##' @param dat data
##' @export
grepInOrder <- function(coln, yrs, dat) {
    unlist(sapply(paste0(coln, yrs), function(x) grep(x, names(dat))))
}

##' General if a null then b function
##' 
##' @param a if a is NULL then b
##' @param b b
##' @export
`%||%` <- function(a, b) if (!is.null(a)) a else b

##' Create empty data.frame with all possible names of supplied arguments
##' 
##' @param ... data.frame types we want the names of
##' @return empty data.frame with union of names of passed objects
##' @export
blankDF <- function(...) {
    ns <- Reduce(union, lapply(list(...), names))
    dat <- setNames(as.list(integer(length(ns))), ns)
    as.data.frame(dat)[0,]
}

##' remove nulls/empty values from list
##' 
##' @param lst List to clean.
##' @param check_nested logical determines if nested lists should be unlisted.
##' @return Cleaned list
##' @export
nonEmpty <- function(lst, check_nested=TRUE) {
    if (check_nested) {
        lst[vapply(lst, function(i) 
            !is.null(i) && 
            length(unlist(i, use.names=FALSE)), logical(1))]
    } else {
        lst[vapply(lst, function(i) 
            !is.null(i) && 
            length(i), logical(1))]
    }
}
