library(leaflet)
library(ShinyDash)

row <- function(...) {
  tags$div(class="row", ...)
}

col <- function(width, ...) {
  tags$div(class=paste0("span", width), ...)
}

actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(bootstrapPage(
  tags$head(tags$link(rel='stylesheet', type='text/css', href='styles.css')),
  leafletMap(
    "map", "100%", 400,
    initialTileLayer = "https://{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
    initialTileLayerAttribution = HTML('Maps by <a href="https://www.mapbox.com/">Mapbox</a>'),
    options=list(
      center = c(37.45, -93.85),
      zoom = 4,
      maxBounds = list(list(17, -180), list(59, 180))
    )
  ),
  tags$div(
    class = "container",
    
    tags$p(tags$br()),
    row(
      col(3, tags$br()),
      col(8, h2('Population of U.S. Cities'))
    ),
    row(
      col(
        3,
        actionLink('randomLocation', 'Go to random location'),
        checkboxInput('addMarkerOnClick', 'Add marker on click', FALSE)
      ),
      col(
        8,
        htmlWidgetOutput(
          outputId = 'desc',
          HTML(paste(
            'The map is centered at <span id="lat"></span>, <span id="lng"></span>',
            'with a zoom level of <span id="zoom"></span>.<br/>',
            'Top <span id="shownCities"></span> out of <span id="totalCities"></span> visible cities are displayed.'
          ))
        )
      )
    ),
    tags$hr(),
    row(
      col(
        3,
        selectInput('year', 'Year', c(2000:2010), 2010),
        selectInput('maxCities', 'Maximum cities to display', choices=c(
          5, 25, 50, 100, 200, 500, 2000, 5000, 10000, All = 100000
        ), selected = 100)
      ),
      col(
        4,
        conditionalPanel(
          condition = 'output.data',
          h4('Visible cities')
        ),
        tableOutput('data')
      ),
      col(
        4,
        conditionalPanel(
          condition = 'output.cityTimeSeries && output.cityTimeSeries.src',
          h4(id='cityTimeSeriesLabel', class='shiny-text-output'),
          plotOutput('cityTimeSeries', width='100%', height='200px')
        ),
        conditionalPanel(
          condition = 'output.markers',
          h4('Marker locations'),
          actionLink('clearMarkers', 'Clear markers')
        ),
        tableOutput('markers')
      )
    )
  )
))
