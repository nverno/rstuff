##' Function to replace variables in function body
##' expr is `body(f)`, keyvals is a lookup table for replacements
##'
##' @param expr body of function for example, ie `body(func)`
##' @param keyvals named lookup
##' @return new expression with substituted variables
##' @export
##' @examples
##' # replace the formals of a function and its body variables
##' # http://stackoverflow.com/questions/33850219/change-argument-names-inside-a-function-r
##' \dontrun{
##'   f <- function(x, y) -x^2 + x + -y^2 + y
##'   newvals <- c('x'='x0', 'y'='y0')      # named lookup vector
##'   newbod <- rep_vars(body(f), newvals)  # create new body
##'   # Rename the formals, and update the body
##'   formals(f) <- pairlist(x0=bquote(), y0=bquote())
##'   body(f) <- newbod
##' }
##' @export
rep_vars <- function(expr, keyvals) {
    if (!length(expr)) return()
    for (i in seq_along(expr)) {
        if (is.call(expr[[i]])) expr[[i]][-1L] <- Recall(expr[[i]][-1L], keyvals)
        if (is.name(expr[[i]]) && deparse(expr[[i]]) %in% names(keyvals))
            expr[[i]] <- as.name(keyvals[[deparse(expr[[i]])]])
    }
    return( expr )
}
