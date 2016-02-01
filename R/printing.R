##' Justify strings like in open office or excel so each line is
##' the exact same length (this doesn't do it).
##'
##' @param string input string
##' @param width width of justified outcome.
##' @param fill where additional spaces should be added (default random)
##' @return justifed string
##' @export
justify1 <- function(string, width=getOption('width'), 
                    fill=c('random', 'right', 'left')) {
    strs <- strwrap(string, width=width)
    paste(fill_spaces(strs, width, match.arg(fill)), collapse="\n")
}

##' Justify vector of strings to all be the same length as width
##' by filling with additional spaces.
##' 
##' @param lines Vector of strings
##' @param width Width to make strings
##' @param fill Preference of where to add additional spaces (default is random)
##' @return Justified strings
##' @export
justify <- function(lines, width, fill=c('random', 'right', 'left')) {
    fill <- match.arg(fill)
    tokens <- strsplit(lines, '\\s+')
    res <- lapply(head(tokens, -1L), function(x) {
        nspace <- length(x)-1L
        extra <- width - sum(nchar(x)) - nspace
        reps <- extra %/% nspace
        extra <- extra %% nspace
        times <- rep.int(if (reps>0) reps+1L else 1L, nspace)
        if (extra > 0) {
            if (fill=='right') times[1:extra] <- times[1:extra]+1L
            else if (fill=='left') 
                times[(nspace-extra+1L):nspace] <- times[(nspace-extra+1L):nspace]+1L
            else times[inds] <- times[(inds <- sample(nspace, extra))]+1L
        }
        spaces <- c('', unlist(lapply(times, formatC, x=' ', digits=NULL)))
        paste(c(rbind(spaces, x)), collapse='')
    })
    c(res, tail(tokens, 1L))
}
