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

##' Modification of Sys.which that can find the ImageMagik convert.exe
##' 
##' Find the correct .exe on Windows.
##' @seealso \link[stackoverflow]{http://stackoverflow.com/questions/34030087/how-to-find-correct-executable-with-sys-which-on-windows}
##' @param cmd System command to find
##' @export
Sys.which2 <- function(cmd) {
    stopifnot(length(cmd) == 1)
    if (.Platform$OS.type == "windows") {
        suppressWarnings({
            pathname <- shell(sprintf("where %s 2> NUL", cmd), intern=TRUE)[1]
        })
        if (!is.na(pathname)) return(setNames(pathname, cmd))
    }
    Sys.which(cmd)
}

##' Can use this to compare compressed archives for example
##' 
##' @seealso \link[stackoverflow]{http://stackoverflow.com/questions/34189716/test-if-compressed-archives-contain-same-data/34191638#34191638}
##' @title binRead
##' @param fName Filename
##' @return bytes
##' @author bluefish (SO tag)
binRead <- function(fName){
  f_s <- file.info(fName)$size
  f <- file(fName,"rb")
  res <- readBin(f, "raw", f_s)
  close(f)
  return(res)
}

