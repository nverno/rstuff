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

##' Create directory tree
##'
##' @title Directory tree
##' @param directory directory to make a tree of
##' @return environment of class dirtree
##' @export
dirtree <- function(directory) {
  owd <- setwd(directory)
  on.exit(setwd(owd))
  nodes <- as.environment(list("0"=list("ht"=0, "parent"=NULL, "cs"=NULL, "depth"=0)))
  num <- (function() { i <- 0; function(x) { 
    if (x > 0) { out <- paste((i+1):(i+x)); i<<-i+x; out }}})()

  inc <- function(node, size, children) {
    if (is.null(node)) return()
    nodes[[node]][["ht"]] <<- size + nodes[[node]][["ht"]]
    if (!missing(children))
      nodes[[node]][["cs"]] <<- c(nodes[[node]][["cs"]], children)
    inc(nodes[[node]][["parent"]], size)
  }

  make_tree <- function(d, parent, depth) {
    files <- list.files(d, full.names = TRUE)
    ids <- num(length(files))
    invisible(inc(parent, length(files), ids))
    for (i in seq_along(ids)) {
      nodes[[ids[[i]]]] <<- list("ht"=0, "parent"=parent, "cs"=list(), 
        "name"=basename(files[[i]]), "depth"=depth)
      make_tree(files[[i]], ids[[i]], depth+1)
    }
  }

  invisible(make_tree(".", "0", 1))
  structure(nodes, class="dirtree")
}

##' Print out dirtree object
##' 
##' @title Print dirtree
##' @param x dirtree
##' @param width width of horizontal seps
##' @param rootname name of root node
##' @param hsep horizontal sep bar
##' @param vsep vertical sep char
##' @export
print.dirtree <- function(x, width=2, rootname="root", hsep='-', vsep='|') {
  w <- paste(rep(hsep, width), collapse='')
  blank <- paste(rep(' ', width+1), collapse='')
  cat(paste0(rootname, '\n'))
  
  stack <- "0"
  while (length(stack)) {
    current <- x[[stack[[1]]]]
    if (current$depth)
      cat(do.call(paste, list(c(
        rep(blank, current$depth-1), vsep, w, current$name, '\n'), collapse='')))
    stack <- c(current[["cs"]], stack[-1L])
  }
  cat('\n')
}
