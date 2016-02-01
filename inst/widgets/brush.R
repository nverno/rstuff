######################################################################
## Modified linked_brush to work with reactive data
## http://stackoverflow.com/questions/28491576/linked-brush-in-ggvis-cannot-work-in-shiny-when-data-change
mylinked_brush <- function(keys, fill = "red") {
    stopifnot(is.character(fill), length(fill) == 1)

    rv <- shiny::reactiveValues(under_brush = character(), keys = character())
    rv$keys <- isolate(keys)

    input <- function(vis) {
        handle_brush(vis, fill = fill, on_move = function(items, ...) {
            rv$under_brush <- items$key__
        })
    }

    set_keys <- function(keys) {
        rv$keys <- keys
    }

    set_brush <- function(ids) {
        rv$under_brush <- ids
    }

    selected_r <- reactive(rv$keys %in% rv$under_brush)
    fill_r <- reactive(c("black", fill)[selected_r() + 1])

    list(
        input = input,
        selected = create_broker(selected_r),
        fill = create_broker(fill_r),
        set_keys = set_keys,
        set_brush = set_brush
    )
}
