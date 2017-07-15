shinyUI(navbarPage(
  title = 'Flow and Habitat App (beta)',
  windowTitle = 'Flow and Habitat Relationship - Sacramento River',
  collapsible = TRUE,
  theme = shinytheme('paper'),
  tabPanel('Upper Sacramento River', 
           flow_habitatUI('up')),
  tabPanel('Middle Sacramento River', 
           flow_habitatUI('mid')),
  tabPanel('Lower Sacramento River', 
           flow_habitatUI('low'))
))
