##' Install, keep source, untar, and unlink, and make a tags file. 
##' Assumes an environment variable 'R_SRC' has been set to the directory
##' where source should be stored.
##'
##' @param pkg Vector of package names (strings)
##' @param tag Logical to use rtags to tag source (default TRUE).
##' @param ... Passed to install.packages
##' @export
install_packages <- function(pkg, tag=TRUE, ...) {
    src <- Sys.getenv("R_SRC")
    if (!length(src)) stop("No 'R_SRC' has been set.")

    install.packages(pkg, type="source", destdir=src, ...)
    ## pkgfiles <- file.path(src, Vectorize(grep)(sprintf("^%s", pkg),
    ##                                list.files(src, pattern="\\.gz$"), value = TRUE))
    pkgfiles <- list.files(src, pattern="\\.gz$", full.names=TRUE)
    for (pack in pkgfiles) untar(pack, exdir = src)
    unlink(pkgfiles)

    pkgdirs <- gsub('_.*.tar\\.gz$', '', pkgfiles)  # _* corresponds to version numbers
    if (tag) {
        for (pack in pkgdirs) utils::rtags(pack, recursive = TRUE,
                                            ofile=file.path(pack, "RTAGS"))
    }
}

##' Clean all tar files from source dir
##'
##' @param pattern file extension pattern of files to remove
##' @export
clean_src <- function(pattern="\\.gz$") {
    src <- Sys.getenv("R_SRC")
    if (!length(src)) stop("No 'R_SRC' has been set.")
    unlink(normalizePath(list.files(src, pattern=pattern, full.names = TRUE)))
}

