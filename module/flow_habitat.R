flow_habitatUI <- function(id) {
  
  ns <- NS(id)
  
  tagList(
    fluidRow(
      column(width = 12,
             tags$h5('Flow and Habitat Relationship'),
             withSpinner(plotlyOutput(ns('area')), color = '#666666', type = 8))),
    fluidRow(
      column(width = 10,
             tags$h5('1922-2003 Cal Lite Simulated flows'),
             withSpinner(plotlyOutput(ns('flow')), color = '#666666', type = 8),
             uiOutput(ns('fp_thresh_text'))))
  )
  
}

flow_habitat <- function(input, output, session, river_section) {
  
  output$fp_thresh_text <- renderUI({
    tags$h6(paste0('dashed gold line denotes floodplain threshold (', pretty_num(fp_hab()$threshold, 0), ' cfs)'))
  })
  
  shed_flow <- reactive({
    filter(sim_flow, shed == river_section)
  })
  
  shed_hab <- reactive({
    filter(habitat, location == river_section)
  })
  
  fp_hab <- reactive({
    fp_lookup %>% 
      filter(location == river_section)
  })
  
  output$area <- renderPlotly({

    xan <- fp_hab()$threshold + (max(shed_hab()$flow) - min(shed_hab()$flow)) * .1 
    yan <- (max(shed_hab()$acres))/2

    plot_ly(data = shed_hab(), x = ~flow, y = ~acres, color = ~stage, type = 'scatter', mode = 'lines', colors = 'Dark2',
            hoverinfo = 'text', text = ~paste(stage, '<br>',pretty_num(flow), 'cfs<br>', pretty_num(acres), 'acres')) %>%
      add_lines(x = c(fp_hab()$threshold, max(shed_hab()$flow)), y = max(shed_hab()$acres) + 10, inherit = FALSE, fill = 'tozeroy',
                line = list(color = 'rgba(189,189,189, 0.1)'), hoverinfo = 'none', name = 'floodplain activated') %>%
      layout(annotations = list(x = xan, y = yan, xref = "x", yref = "y", showarrow = FALSE, 
                                text = paste('additional', fp_hab()$fp_hab_acres,'acres of <br>floodplain habitat available')),
             yaxis = list(title = 'available habitat (acres)'),
             xaxis = list(title = 'flow (cfs)')) %>%
      config(displayModeBar = FALSE)

  })

  output$flow <- renderPlotly({
    p <- shed_flow() %>% 
      ggplot(aes(x = fct_inorder(month.name[month]), y = flow, text = paste(pretty_num(flow), 'cfs'))) +
      geom_boxplot() +
      geom_jitter(width = .2, size = 1, alpha = .2, stroke = 0) +
      geom_hline(yintercept = fp_hab()$threshold, linetype = 'dash', size = .3, color = 'darkgoldenrod3') +
      theme_minimal() +
      labs(y = 'flow (cfs)', x = '')
    
    ggplotly(p, tooltip = 'text')%>% 
      config(displayModeBar = FALSE)
    
  })
}