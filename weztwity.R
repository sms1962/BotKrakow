# pobieranie_twitow

library(rtweet)

botkrakow_token <- rtweet::create_token(
  app = "BotKrakow",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

df <- get_timeline(user = "botkrakow", n=50, token = botkrakow_token)

nazwa <- paste0("./data/botkrakow_twity_",Sys.Date(), ".RDS")

saveRDS(df, file = nazwa)
