library(shiny)
library(leaflet)

shinyUI(navbarPage("Edmonton Traffic Volume Visualizer", id="nav",
    tabPanel("Interactive Map",
        div(class = "outer",
            tags$head(
                includeCSS("style.css"),
                includeScript("gomap.js")
            ),
            leafletMap("map", width="100%", height="100%",
                initialTileLayer = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
                options=list(
                    center = c(53.533845, -113.494635),
                    zoom = 11
                )
            ),
            absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                width = 330, height = "auto",
                          
                h2("Traffic Explorer")
            ),
            withTags(
                div(id="cite",
                    'Data collected from the City of Edmonton: ', a(href = 'http://www.edmonton.ca/transportation/traffic_reports/traffic-volumes-turning-movements.aspx', 'Traffic Volumes and Turning Movements Source')
                )
            )
        )
    ),
    tabPanel("View Data")
))