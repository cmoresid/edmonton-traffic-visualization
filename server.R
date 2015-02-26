library(shiny)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

shinyServer(function (input, output, session) {
    map <- createLeafletMap(session, "map")
    
    # session$onFlushed is necessary to work around a bug in the Shiny/Leaflet
    # integration; without it, the addCircle commands arrive in the browser
    # before the map is created.
    session$onFlushed(once=TRUE, function() {
        paintObs <- observe({
            # Clear existing circles before drawing
            map$clearShapes()
            # Draw in batches of 100; makes the app feel a bit more responsive
            chunksize <- 100
            
            for (from in seq.int(1, nrow(sites), chunksize)) {
                to <- min(nrow(sites), from + chunksize)
                sitechunk <- sites[from:to,]
                # Bug in Shiny causes this to error out when user closes browser
                # before we get here
                try(
                    map$addCircle(
                        sitechunk$latitude, sitechunk$longitude, layerId = sitechunk$site_id
                    )
                )
            }
        })
        
        # TIL this is necessary in order to prevent the observer from
        # attempting to write to the websocket after the session is gone.
        session$onSessionEnded(paintObs$suspend)
    })
    
    # Show a popup at the given location
    showSiteInformationPopup <- function(siteId, lat, lng) {
        selectedSite <- sites %>% filter(site_id == siteId)
        content <- as.character(tagList(
            tags$h4("Site ID:", as.integer(selectedSite$site_id)),
            sprintf("Address: %s", selectedSite$address), tags$br(),
            sprintf("Average Daily Traffic: %s", selectedSite$adt), tags$br(),
            sprintf("Street Type: %s", selectedSite$street_type), tags$br(),
            sprintf("Primary Purpose: %s", selectedSite$primary_purpose), tags$br()
        ))
        
        map$showPopup(lat, lng, content, siteId)
    }
    
    # When map is clicked, show a popup with city info
    clickObs <- observe({
        map$clearPopups()
        event <- input$map_shape_click
        if (is.null(event))
            return()
        
        isolate({
            showSiteInformationPopup(event$id, event$lat, event$lng)
        })
    })
    
    session$onSessionEnded(clickObs$suspend)
})