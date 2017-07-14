upsac <- read_csv('data-raw/uppersac.csv') %>% 
  mutate(location = 'upsac') %>% 
  select(flow = `Flow (cfs)`, acres, stage, location)

midsac <- read_csv('data-raw/midsac.csv') %>% 
  select(flow = NAA_Flow_cfs, habitat = NAA_Pref_Velocity_Depth_TotArea_Acres) %>% 
  mutate(fry = habitat * .5, parr = habitat * .5, location = 'midsac') %>% 
  gather(stage, acres, -flow, - location, -habitat) %>% 
  select(flow, acres, stage, location)

lowsac <- read_csv('data-raw/lowersac.csv') %>% 
  select(flow = NAA_Flow_cfs, habitat = NAA_Pref_Velocity_Depth_TotArea_Acres) %>% 
  mutate(fry = habitat * .5, parr = habitat * .5, location = 'lowsac') %>% 
  gather(stage, acres, -flow, - location, -habitat) %>% 
  select(flow, acres, stage, location)

sac <- bind_rows(upsac, midsac, lowsac)
write_rds(sac, 'data/sac_flow_habitat50.rds') #fry parr split 50/50 for mid to low sac

midsac <- read_csv('data-raw/midsac.csv') %>% 
  select(flow = NAA_Flow_cfs, acres = NAA_Pref_Velocity_Depth_TotArea_Acres) %>% 
  mutate(stage = 'fry + parr', location = 'midsac') %>% 
  select(flow, acres, stage, location)

lowsac <- read_csv('data-raw/lowersac.csv') %>% 
  select(flow = NAA_Flow_cfs, acres = NAA_Pref_Velocity_Depth_TotArea_Acres) %>% 
  mutate(stage = 'fry + parr', location = 'lowsac') %>% 
  select(flow, acres, stage, location)

write_rds(sac, 'data/sac_flow_habitat.rds') #fry and parr combined for mid to low sac
