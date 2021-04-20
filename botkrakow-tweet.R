# Twitter token 
botkrakow_token <- rtweet::create_token(
  app = "botkrakow",
  consumer_key =    Sys.getenv("BOTKRAKOW_TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("BOTKRAKOW_TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("BOTKRAKOW_TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("BOTKRAKOW_TWITTER_ACCESS_TOKEN_SECRET")
)

# Współrzędne punktu w Krakowie .

# lewy dolny: 50.040055838307936, 19.916281923196617
# prawy górny: 50.10115253233459, 20.087548254174763

lon <- round(runif(1, 19.916, 20.087), 4)
# lon <- format(lon, scientific = FALSE)
lat <- round(runif(1, 50.040, 50.101), 4)

# Adres do MapBox API
img_url <- paste0(
  "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/",
  paste0(lon, ",", lat),
  ",15,0/600x400@2x?access_token=",
  Sys.getenv("MAPBOX_PUBLIC_ACCESS_TOKEN")
)

# Pobranie zdjęcia satelitarnego z MapBox
temp_file <- tempfile()
download.file(img_url, temp_file)

# Współrzędne punktu i adres do mapy w OpenStreetMaps
latlon_details <- paste0(
  lat, ", ", lon, "\n",
  "https://www.openstreetmap.org/#map=17/", lat, "/", lon, "/"
)

# Wysłanie twita ze zdjęciem satelitarnym
rtweet::post_tweet(
  status = latlon_details,
  media = temp_file,
  token = botkrakow_token
)