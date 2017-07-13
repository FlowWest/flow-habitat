library(shiny)
library(tidyverse)
library(scales)
library(plotly)
library(forcats)
library(shinycssloaders)

flowz <- read_csv('data/flow_temperature.csv') %>% 
  filter(watershed == "Upper Sacramento River")

upsac <- read_csv('data/uppersac.csv') %>% 
  rename(flow = `Flow (cfs)`) %>% 
  mutate(floodplain_acres = case_when(
    stage == 'spawning' ~ 0,
    flow >= 21000 ~ 649.9,
    flow < 21000 ~ 0)) %>% 
  select(flow, stage, acres, floodplain_acres)

dumby <- tibble(
  flow = rep(21000, 2),
  stage = c('fry', 'parr'),
  acres = c(29.026827, 8.270343),
  floodplain_acres = rep(0, 2)
)  
reorder <- c(13, 1:6, 14, 7:12)
upsac_fp <- upsac %>% 
  filter(flow >= 21000, stage != 'spawning') %>% 
  bind_rows(dumby)

upsac_fp <- upsac_fp[reorder,]

upsac %>% 
  ggplot(aes(x = flow, y = acres, color = stage)) +
  geom_line() +
  geom_line(data = upsac_fp, 
            aes(x = flow, y = floodplain_acres + acres, color = stage)) +
  scale_x_continuous(labels = comma) +
  theme_minimal()

pretty_num <- function(num, places = 2) {
  format(round(num, places), big.mark = ',', drop = FALSE)
}
