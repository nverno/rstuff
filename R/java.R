##' Set some environment variables required by some packages.
##' 
##' @param home Path for JAVA_HOME
##' @param javac Path to javac (probably same as HOME)
##' @param jvm Path to jvm.dll (/path/to/jdk/jre/bin/server/)
##' @param overwrite If true, overwrite JAVA_HOME
add_java_env <- function(home="C:\\Program Files\\Java\\jdk1.8.0_66\\bin",
                         javac=home,
                         jvm="C:\\Program Files\\Java\\jdk1.8.0_66\\jre\\bin\\server",
                         overwrite=FALSE) {
    ## JAVA_HOME
    if (overwrite || !nzchar(Sys.getenv("JAVA_HOME")))
        Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jdk1.8.0_66\\bin")

    ## javac and jvm.dll
    Sys.setenv(PATH=paste(c(Sys.getenv("PATH"), 
                            Sys.getenv("JAVA_HOME"),
                            "C:\\Program Files\\Java\\jdk1.8.0_66\\jre\\bin\\server"),
                          collapse=";"))
    invisible()
}
