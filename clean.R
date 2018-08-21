# Packages used ---------

library(xlsx)
library(tm)
library(stringr)
library(tidyverse)
library(tidytext)

#setwd("C:/Users/Nish/Documents/5120/agedcare_finder/data/")
# aged care residential
acr <- read.csv("./data/Aged-Care-Homes-June-2018.csv")
# aged care home
ach <- read.csv("./data/HCP-June-2018.csv")

dim(acr)
dim(ach)

# Removing unecessary variables -----------

# what do these X ones even do? probably just errors from xlsx -> csv
ach$X <- NULL
ach$X.1 <- NULL
ach$X.3 <- NULL
ach$X.4 <- NULL

# These aren't needed
ach$MAX_EXIT_AMOUNT <- NULL

## Hours worked
# opening hours
open_hours_std <- unlist(lapply(X = ach$HOURS_STANDARD, FUN = str_extract, pattern = ".+?(?=\\s-)"))
# closing hours
close_hours_std <- unlist(lapply(X = ach$HOURS_STANDARD, FUN = str_extract, pattern = "(?<=-\\s).*"))

ach$DESCRIPTION <- as.character(ach$DESCRIPTION) %>%
    removePunctuation() %>%
    tolower()

# Weird column name
names(ach)[names(ach) == "ï..OUTLET_NAME"] <- "OUTLET_NAME"

# description cleaning
ach$DESCRIPTION <- ach %>%
    unnest_tokens(word, DESCRIPTION) %>%
    anti_join(stop_words, by = "word") %>%
    nest(DESCRIPTION) %>%
    mutate(text = map(ach, unlist),
           text = map_chr(text, paste, collapse = " "))
# removing stop words
dc <- ach %>%
    unnest_tokens(word, DESCRIPTION)

# AUX Functions -----------
# get lat/lng from string address 
address_code <- function(address){
  library(RJSONIO)
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))
  test <- fromJSON(url, simplify = FALSE)
  if (test$status == "OK"){
    out <- c(test$results[[1]]$geometry$location$lng,
             test$results[[1]]$geometry$location$lat)
  }
  else{
    out <- NA
  }
  Sys.sleep(0.2)
  return(out)

}
# adress from individual observations
create_address_string <- function(row_number, data_set){
  row <- data_set[row_number,]
  out <- paste(row$BUS_ST_ADDRESS, row$BUS_SUBURB, row$BUS_PCODE, sep = "")
  return(out)
}
