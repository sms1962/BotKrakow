# Twitter token 
botkrakow_token <- rtweet::create_token(
  app = "BotKrakow",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

# Losowanie punktu w Krakowie .

# Tylko Kraków, to znaczy bbox i tym samym punkt w granicach administracyjnych Krakowa

lon <- round(runif(1, 19.875, 20.111), 4)
lat <- round(runif(1, 50.040, 50.093), 4)

# Tworzenie url do pobraniazdjęcia satelitarnego

img_url <- paste0(
  "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/",
  paste0("pin-l-marker+015(",lon,",",lat,")/", lon, ",", lat),
  ",15,0/850x500?access_token=",
  Sys.getenv("MAPBOX_PUBLIC_ACCESS_TOKEN")
)

# Pobranie zdjęcia satelitarnego z MapBox

temp_file <- tempfile()
download.file(img_url, temp_file)

# Treść twita

latlon_details <- paste0("Jestem botem, który co 1 h wybiera losowo punkt w #Krakow.ie, pobiera zdjęcie satelitarne. Poniżej pkt o współ.: ", lat, ", ", lon, " \n", "Nie poznajesz? Zobacz na mapie. ",
  "https://www.openstreetmap.org/#map=17/", lat, "/", lon, "/"
)

# Wysłanie twita ze zdjęciem satelitarnym
rtweet::post_tweet(
  status = latlon_details,
  media = temp_file,
  token = botkrakow_token
)
