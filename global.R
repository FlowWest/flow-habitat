library(shiny)
library(tidyverse)
library(scales)
library(plotly)
library(forcats)
library(shinycssloaders)

source('module/flow_habitat.R')

pretty_num <- function(num, places = 2) {
  format(round(num, places), big.mark = ',', drop = FALSE)
}

shed_lookup <- c('upsac', 'midsac', 'lowsac', 'lowsac')
names(shed_lookup) <- c("Upper Sacramento River", "Upper-mid Sacramento River", 
                        "Lower-mid Sacramento River", "Lower Sacramento River")

sim_flow <- read_csv('data/flow_temperature.csv') %>% 
  filter(watershed %in% c("Upper Sacramento River", "Upper-mid Sacramento River",
                          "Lower-mid Sacramento River", "Lower Sacramento River")) %>% 
  mutate(shed = shed_lookup[watershed]) %>% 
  group_by(shed, year, month) %>% 
  summarise(flow = sum(flow)) %>% 
  ungroup()

habitat <- read_rds('data/sac_flow_habitat.rds')
fp_lookup <- tibble(
  location = c('upsac', 'midsac', 'lowsac'),
  threshold = c(21000, 15555, 39019),
  fp_hab_acres = c(650, 912.9, 52.1)
)

