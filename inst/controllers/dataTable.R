### dataTable.R --- 
## Filename: dataTable.R
## Description: 
## Author: Noah Peart
## Created: Fri Oct 23 00:15:11 2015 (-0400)
## Last-Updated: Tue Oct 27 18:30:51 2015 (-0400)
##           By: Noah Peart
######################################################################

output$dataTable <- DT::renderDataTable(expr={
    caption <- isolate({
        if (is.null(input$data)) {
            "No data selected"
        } else if (input$data == 'tp') {
            "Selected Transect Data"
        } else if (input$data == 'pp') {
            "Selected Permanent Plot Data"
        } else "No data selected"
    })
    tabdat <- dat()
    suppressWarnings(
        DT::datatable(tabdat, caption=caption, filter='bottom', rownames=FALSE,
                      class='cell-border stripe',
                      options=list(pageLength=5, autoWidth=TRUE))
    )
})
