fluidPage(
  fluidRow(
    column(width = 12,
           tags$h1('Upper Sacramento River')
    )
  ),
  fluidRow(
    column(width = 12,
           tags$h4('Flow and Habitat Relationship'),
           withSpinner(plotlyOutput('area'), color = '#666666', type = 8))),
  fluidRow(
    column(width = 10,
           tags$h4('1922-2003 Cal Lite Simulated flows'),
           withSpinner(plotlyOutput('flow'), color = '#666666', type = 8)))
)
