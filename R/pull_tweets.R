#####SENTIMENT ANALYSIS OF THE COVID-19 VACCINE IN SOUTH FLORIDA --------------
## Source: Twitter
#-------------------------------------------------------------------------------
library(rtweet)
library(tidyverse)
#remotes::install_github("rstudio/httpuv")
#verify token - a twitter developer acct is no longer necessary to pull data
get_token()

## search for 10,000 tweets sent from florida
query <- "vaccine OR Covid-19 OR Moderna OR Pfizer"
vaccine <- search_tweets(
  query, 
  geocode = lookup_coords("florida", apikey = Sys.getenv("GOOGLE_MAPS_API_KEY")), 
  n = 2000,
  retryonratelimit = TRUE
)
#date rangees 1/26 to 2/02
## create lat/lng variables using all available tweet and profile geo-location data
vaccine <- lat_lng(vaccine)

saveRDS(vaccine, paste0("./data/vaccine", Sys.Date(),".rds"))

#more data since 02/02-02/05
vaccine_0205 <- search_tweets(
  query, 
  geocode = lookup_coords("florida", apikey = Sys.getenv("GOOGLE_MAPS_API_KEY")), 
  n = 2000,
  retryonratelimit = TRUE
)
#n = 17,900
vaccine_0205 <- lat_lng(vaccine_0205)
saveRDS(vaccine_0205,"./data/vaccine2021-02-05.rds")

#data since 02/05-02/08
vaccine_0208 <- search_tweets(
  query, 
  geocode = lookup_coords("florida", apikey = Sys.getenv("GOOGLE_MAPS_API_KEY")), 
  n = 2000,
  retryonratelimit = TRUE
)
#n = 17,935
vaccine_0208 <- lat_lng(vaccine_0208)
saveRDS(vaccine_0208,"./data/vaccine2021-02-08.rds")

#join past corona twitter data
vaccine_tweets <- map_dfr(list.files("./data/", pattern = "vaccine", 
                                    full.names = TRUE),
                         function(x){
                           read_rds(x) %>% 
                             bind_rows()
                         })
saveRDS(vaccine_tweets, "./data/tweets_cum.rds")
## plot state boundaries
par(mar = c(0, 0, 0, 0))
maps::map("county", "florida", lwd = .25)

## plot lat and lng points onto state map
with(vaccine_0208, points(lng, lat, pch = 20, cex = .75, 
                           col = rgb(0, .3, .7, .75)))


##REQUIRES PREMIUM ACCESS------------------------------------------------------
# query_simple <- "vaccine bounding_box:[-87.447524,24.412531,-79.515395,30.728040]"
# query_simple <- "coronavirus bounding_box:[west_long south_lat east_long north_lat]"
# 
# corona_archive <- search_fullarchive(
#   query_simple, n = 500, fromDate = "202003110000", toDate = "202004162359",
#   safedir = "./data", parse = TRUE
# )
# 
# vaccine_30day <- search_30day(
#   query_simple, n = 500, toDate = "202102082359",
#   safedir = "./data", parse = TRUE
# )
