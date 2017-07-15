shinyServer(function(input, output) {
  callModule(flow_habitat, 'up', river_section = 'upsac')
  callModule(flow_habitat, 'mid', river_section = 'midsac')
  callModule(flow_habitat, 'low', river_section = 'lowsac')
})


