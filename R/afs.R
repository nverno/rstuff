### afs.R --- 
## Filename: afs.R
## Description: Loading raw files off AFS
## Author: Noah Peart
## Created: Mon Feb  8 23:42:46 2016 (-0500)
## Last-Updated: Mon Feb  8 23:58:05 2016 (-0500)
##           By: Noah Peart
######################################################################

##' Grab files off AFS
##' 
##' @param files R names of files to get
##' @keywords internal
load_data <- function(files) {
  res <- lapply(files, sync.afs::get_data)
  names(res) <- files
  res
}

##' Copy data from AFS and create roxygen documentation.
##' 
##' @param files Data files to get from AFS
##' @param basedir base directory (default to '.')
##' @param descriptions Optional data descriptions
##' @param capitalize If true, capitalize the variable names
##' @param datadir Name of output directory for data (Default to 'data')
##' @param docdir Name of output directory for files produced by datadoc::describe (default 'R')
##' @param add_tables If true, add tables to documentation.
##' @param ... passed to datadoc::describe
##' @export
setup_data <- function(files, basedir='.', descriptions, capitalize=TRUE,
                       datadir='data', docdir="R", add_tables=TRUE, ...) {
  if (!requireNamespace('sync.afs')) {
    warning('this requires nverno/sync.afs package')
    return(invisible())
  }
  dat <- load_data(files)
  
  ## Capitalize variables
  if (capitalize) for(d in dat) setnames(d, names(d), toupper(names(d)))
  e <- new.env()
  list2env(dat, e)

  ## Add boilerplate descriptions
  if (missing(descriptions)) descriptions <- names(files)
  for(i in seq_along(files)) {
    n <- names(dat)[[i]]
    
    if (requireNamespace('datadoc')) {
      ## Add documentation file for roxygen
      datadoc::describe(n, text=descriptions[i], 
        outfile=file.path(basedir, docdir, paste0(n, '.R')), 
        add_tables=add_tables, envir=e, ...)
    } else {
      message('cant document the data without package nverno/datadoc.')
    }
    
    ## save in data
    save(list=n, envir=e,
      file=file.path(basedir, datadir, paste0(n, '.rda')), 
      compress='bzip2')
  }
  invisible()
}

##' Copy documents over from AFS
##' 
##' @param docs Documents to copy
##' @param outdir Directory to copy to (or an "./inst/docs/" directory is created)
##' @export
load_docs <- function(docs, outdir) {
  if (!requireNamespace("sync.afs")) {
    warning('this function requires nverno/sync.afs package.')
    return(invisible())
  }
  if (!exists('afs')) afs <- sync.afs::AFS$new()
  if (!afs$connected()) afs$signin()
  if (missing(outdir)) {  # assume we making docs in ints/docs
    message('Documents being copied to ./inst/docs')
    outdir <- file.path('inst', 'docs')
    if (!file.exists('inst')) dir.create('inst')
    if (!file.exists(outdir)) dir.create(outdir)
  }
  paths <- sync.afs::get_key()[list(rname=docs), afs_path, on='rname']
  docnames <- basename(paths)
  paths <- file.path(afs$path, paths)
  res <- for (i in seq_along(docs)) {
    if (!file.exists(paths[[i]])) stop(sprintf("Can't find %s", paths[[i]]))
    file.copy(from=paths[[i]], to=file.path(outdir, docnames[[i]]))
  }
}
