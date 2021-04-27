# logowanie twitow - tworzenie archiwum

# autoryzacja
library(rtweet)
library(tidyverse)
library(lubridate)

botkrakow_token <- rtweet::create_token(
  app = "BotKrakow",
  consumer_key =    Sys.getenv("TWITTER_CONSUMER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_CONSUMER_API_SECRET"),
  access_token =    Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret =   Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET")
)

# pobranie ostatnich twitow (max 100)
df <- get_timeline(user = "botkrakow", n=50, token = botkrakow_token)

df_dzisiejsze <- df %>% 
  filter(created_at >= ymd(Sys.Date(), tz="Europe/Warsaw")) %>%
  select(user_id, status_id, created_at, text, favorite_count, retweet_count, followers_count, statuses_count) %>% 
  mutate_all(as.character)


# tylko do zrobienia pliku testowego

# zapis_testowy <- df_dzisiejsze[-1:-2,]
# head(df_dzisiejsze$created_at,1)
# head(zapis_testowy$created_at,1)
# write_csv(zapis_testowy,"./data/test_log.csv")

# pobranie aktualnego loga

log_data <- read_csv("./data/archiwum_twitow.csv", 
                   col_types = cols(user_id = col_character(), 
                                    status_id = col_character(), created_at = col_character(),
                                    favorite_count = col_character(), retweet_count = col_character(),
                                    followers_count = col_character(), statuses_count = col_character()))

# wybieram wiersze do archiwzacji
# log_new_data <- df_dzisiejsze %>% 
#   bind_rows(log_data) %>% 
#   distinct(status_id, .keep_all = TRUE)

log_new_data <- anti_join(df_dzisiejsze, log_data, by = "status_id")

# dodanie do istniejącego loga na dysku nowych twitow

write_csv(log_new_data,"./data/archiwum_twitow.csv",append = TRUE)


