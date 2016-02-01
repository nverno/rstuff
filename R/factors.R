##' If the underlying variable is numeric, like PPLOT,
##' lets order the factor numerically, otherwise use a standard
##'
##' @param v Variable
##' @return Order of levels
##' @importFrom stringr str_detect
##' @export
levOrder <- function(v) {
    if (any(stringr::str_detect(v, "[[:alpha:]]"), na.rm=TRUE)) {
        sort(unique(na.omit(v)))
    } else sort(unique(as.numeric(as.character(v))))
}
