##' Find paths to data in specified diretories
##' 
##' @param locs directories to search
##' @param files names of files to look for
##' @param throw_error if specified, throw errow when not found
##' @return list of two character vectors: found files, missed files
##' @export
findData <- function(locs, files, throw_error=TRUE) {
  found <- c()
  for (loc in locs) {
    if (any((present <- file.exists(file.path(loc, files))))) {
      found <- c(found, file.path(loc, files[present]))
      files <- files[!present]
    }
    if (length(files) == 0)
      break
  }
  if (throw_error && length(files))
    stop(paste("\nMissing:", files, collapse=","))
  return( list(found=found, missed=files) )
}

##' Gathers requires/libraries
##'
##' @param dirs Directories to search
##' @param fnames Filenames to search in (optional)
##' @param pattern File extension of files to search
##' @param recursive If true, search recursively
##' @export
findPacks <- function(dirs='.', fnames=NULL, pattern='.*\\.[Rr]+', recursive=TRUE) {
    files <- list.files(dirs, full.names=TRUE, pattern=pattern, recursive=recursive)
    if (!is.null(fnames)) files <-
        unlist(Vectorize(grep, "pattern")(fnames, files, fixed=TRUE, value=TRUE),
               use.names=FALSE)
    patt <- paste(paste0(c("require", "library"), "*?\\(([^)]+)\\).*"), collapse="|")
    reqs <- sapply(files, function(file) {
        lines <- sub("(^[^#]*).*", "\\1", readLines(file))
        lines <- lines[length(lines)>0 & lines != ""]
        unlist(lapply(lines, function(line)
            regmatches(line, gregexpr(patt, line))))
    })
    reqs <- unlist(reqs, use.names = FALSE)
    reqs <- if(length(reqs)>0) unlist(strsplit(reqs, "\\s+|;"))
    res <- (s <- sub(".*\\(([^)]+)\\).*", "\\1", reqs))[s!=""]
    res
}

##' Wrapper for file.access to test file write permissions.
##' From \code{dplyr}
##' @title Check file write permission.
##' @param x File path
##' @export
is_writeable <- function(x) {
  unname(file.access(x, 2) == 0L)
}

