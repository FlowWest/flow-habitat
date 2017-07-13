shinyServer(function(input, output) {

  output$area <- renderPlotly({
    plot_ly(data = upsac, x = ~flow, y = ~acres, color = ~stage, type = 'scatter', mode = 'lines', colors = 'Dark2',
            hoverinfo = 'text', text = ~paste(stage, '<br>',pretty_num(flow), 'cfs<br>', pretty_num(acres), 'acres')) %>%
      add_lines(y = rep(90, 90), x = seq(21000, 31000, length = 90), inherit = FALSE, fill = 'tozeroy',
                line = list(color = 'rgba(189,189,189, 0.1)'), hoverinfo = 'none', name = 'floodplain activated') %>% 
      layout(annotations = list(x = 26000, y = 70, xref = "x", yref = "y", showarrow = FALSE, ax = 0, ay = 0,
                                text = 'additional 650 acres of <br>of-channel habitat available'),
             yaxis = list(title = 'available habitat (acres)'),
             xaxis = list(title = 'flow (cfs)')) %>% 
      config(displayModeBar = FALSE)
  })
  
  output$flow <- renderPlotly({
    p <- flowz %>% 
      ggplot(aes(x = fct_inorder(month.name[month]), y = flow, text = paste(pretty_num(flow), 'cfs'))) +
      geom_boxplot() +
      geom_jitter(width = .2, size = 1, alpha = .2, stroke = 0) +
      theme_minimal() +
      labs(y = 'flow (cfs)', x = '')
    
    ggplotly(p, tooltip = 'text')%>% 
      config(displayModeBar = FALSE)
    
  })
  
})


