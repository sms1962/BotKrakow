# Twitter token 
botkrakow_token <- rtweet::create_token(
  app = "BotKrakow",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

# Współrzędne punktu w Krakowie .

# lewy dolny: 49.964621202787704, 19.768131568180056
# prawy górny: 50.14098957526662, 20.21510990888496

# Tylko Kraków

# lewy dolny 50.0408,19.8756
# prawy górny 50.0937,20.1118

# Bbox Krakowa

# lon <- round(runif(1, 19.792, 20.217), 4)
# lon <- format(lon, scientific = FALSE)
# lat <- round(runif(1, 49.967, 50.126), 4)
# lat <- format(lat, scientific = FALSE)

# Tylko Kraków

lon <- round(runif(1, 19.875, 20.111), 4)
lon <- format(lon, scientific = FALSE)
lat <- round(runif(1, 50.040, 50.093), 4)
lat <- format(lat, scientific = FALSE)
# Adres do MapBox API
# https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/

# adres z markerem 
# https://api.mapbox.com/styles/v1/mapbox/light-v10/static/pin-l-marker+015(-87.0186,32.4055)/-87.0186,32.4055,14/500x300?access_token=pk.eyJ1Ijoic21zMTk2MiIsImEiOiJja25wdXUxNnUxczljMnZueGJrZGV5ZjA3In0.tDuvaUPax4YjwaltXy1s5g

# po 600x400 dodany był @2x
img_url <- paste0(
  "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/",
  paste0("pin-l-marker+015(",lon,",",lat,")/", lon, ",", lat),
  ",15,0/850x500?access_token=",
  Sys.getenv("MAPBOX_PUBLIC_ACCESS_TOKEN")
)

# Pobranie zdjęcia satelitarnego z MapBox

temp_file <- tempfile()
download.file(img_url, temp_file)

# Współrzędne punktu i adres do mapy w OpenStreetMaps

latlon_details <- paste0("Jestem botem, który co 1 h wybiera losowo punkt w #Krakow.ie, pobiera zdjęcie satelitarne. Poniżej pkt o współ.: ", lat, ", ", lon, " \n", "Nie poznajesz? Zobacz na mapie. ",
  "https://www.openstreetmap.org/#map=17/", lat, "/", lon, "/"
)

# Wysłanie twita ze zdjęciem satelitarnym
rtweet::post_tweet(
  status = latlon_details,
  media = temp_file,
  token = botkrakow_token
)
