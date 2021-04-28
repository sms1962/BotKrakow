# mapa punktów w leaflet

library(rtweet)
library(tidyverse)
library(leaflet)
library(mapview)


## Pobranie twittów @botkrakow

twity <- read_csv("./data/archiwum_twitow.csv", 
                  col_types = cols(user_id = col_character(), 
                                   status_id = col_character(), created_at = col_character(),
                                   favorite_count = col_character(), retweet_count = col_character(),
                                   followers_count = col_character(), statuses_count = col_character(),
                                   ext_media_url = col_character()))


## ekstrakcja współrzędnych i url zdjęcia satelitarnego

dt <- twity %>% 
  select(status_id, created_at, text, ext_media_url) %>% 
  mutate(lat_lon = str_extract(text, "[:digit:]+\\.[:digit:]+,.?[:digit:]+\\.[:digit:]+")) %>% 
  separate(lat_lon, into=c("lat","lon"),sep = ",") %>% 
  mutate(lat = as.numeric(lat), lon = as.numeric(lon)) %>% 
  mutate(t_url = paste0("https://twitter.com/BotKrakow/status/", status_id))


## rysowanie mapy w Leaflet z punktami


m <- leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>% 
  # addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(dt$lon, dt$lat, clusterOptions = markerClusterOptions(), 
                   popup = paste0("<img src = ", dt$ext_media_url, " width='200' height='150' />"))

## Zapisanie mapy w png

mapview::mapshot(m, url = "_site/index.html")


