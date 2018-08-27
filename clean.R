# Packages used ---------

library(tm)
library(stringr)
library(tidyverse)
library(tidytext)
library(reshape2)


#setwd("C:/Users/Nish/Documents/5120/agedcare_finder/data/")
# aged care residential
#acr <- read.csv("./data/Aged-Care-Homes-June-2018.csv")
# aged care home
ach <- read.csv("./data/HCP-June-2018.csv", fileEncoding="UTF-8-BOM")
# Removing unecessary variables -----------

# what do these X ones even do? probably just errors from xlsx -> csv
ach$X <- NULL
ach$X.1 <- NULL
ach$X.3 <- NULL
ach$X.4 <- NULL

# These aren't needed
ach$MAX_EXIT_AMOUNT <- NULL

# remove blank obs and disclaimer row(s)
ach <- ach[1:4618,]

ach$id <- seq_len(nrow(ach))

# Time -----------------
# opening hours
open_hours_std <- unlist(lapply(X = ach$HOURS_STANDARD, FUN = str_extract, pattern = ".+?(?=\\s-)"))
open_hours_std <- gsub("\\.", ":", open_hours_std)
open_hours_miltime <- format(strptime(open_hours_std, "%I:%M"), format="%H%M")
open_hours_std <- format(strptime(open_hours_std, "%I:%M %p"), format="%H:%M")

ach$OPEN_HOUR <- open_hours_std
ach$OPEN_HOUR_M <- open_hours_miltime
# closing hours
close_hours_std <- unlist(lapply(X = ach$HOURS_STANDARD, FUN = str_extract, pattern = "(?<=-\\s).*"))
close_hours_std <- gsub("\\.", ":", close_hours_std)
close_hours_miltime <- format(strptime(close_hours_std, "%I:%M %p"), format="%H%M")
close_hours_std <- format(strptime(close_hours_std, "%I:%M %p"), format="%H:%M")

ach$CLOSE_HOUR <- close_hours_std
ach$CLOSE_HOUR_M <- close_hours_miltime

ach$HOURS_STANDARD <- NULL
# Address ------------
# consistent state abbv
ach[ach$STREET_STATE == "qld",]$STREET_STATE = "QLD"
# re-factor
ach$STREET_STATE = factor(ach$STREET_STATE)

# Removing NaNs from WEEKEND/EVENINGS
ach[ach$WEEKENDS == "",]$WEEKENDS = "Available"
ach[ach$EVENINGS == "",]$EVENINGS = "Available"
ach$WEEKENDS <- factor(ach$WEEKENDS)
ach$EVENINGS <- factor(ach$EVENINGS)

levels(ach$WEEKENDS) <- c(TRUE, FALSE)
levels(ach$EVENINGS) <- c(TRUE, FALSE)

attr <- ach[!duplicated(ach$OUTLET_NAME),] 
attr$address <- paste(attr$STREET_ST_ADDRESS, attr$STREET_SUBURB, attr$STREET_PCODE, attr$STREET_STATE)
attr <- attr %>%
    select(id, OUTLET_NAME, address, STREET_STATE, STREET_PCODE, STREET_SUBURB, OPEN_HOUR, CLOSE_HOUR, WEEKENDS, EVENINGS) 

attr_m <- ach[!duplicated(ach$OUTLET_NAME),] 
attr_m$address <- paste(attr$STREET_ST_ADDRESS, attr$STREET_SUBURB, attr$STREET_PCODE, attr$STREET_STATE)
attr_m <- attr_m %>%
  select(id, OUTLET_NAME, address, STREET_STATE, STREET_PCODE, STREET_SUBURB, OPEN_HOUR_M, CLOSE_HOUR_M, WEEKENDS, EVENINGS) 

write.csv(x = attr, file = "./data/clean/facility_basic.csv", na = "NaN", row.names = FALSE)
write.csv(x = attr_m, file = "./data/clean/facility_basic_miltime.csv", na = "NaN", row.names = FALSE)



  # NLP ------------
ach$DESCRIPTION <- as.character(ach$DESCRIPTION) %>%
    removePunctuation() %>%
    tolower()


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

# Culture & Language ----------------

cult_df <- ach %>%
  select(id, CULTURE)
  
cult_df$CULTURE <- as.character(cult_df$CULTURE) %>%
  strsplit(",")

cult_df$CULTURE <- lapply(X = cult_df$CULTURE, FUN = gsub, pattern = "^\\s|\\s$", replacement = "")


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

# string AM/PM to 24h time 

to_24h <- function(time_string){
    return("pass")
}


# OUTPUT ------------

export_home <- function(){
    clean_data_home <- melt(data.frame(ach$OUTLET_NAME, 
                                       open_hours_std, 
                                       close_hours_std,
                                       ach$STREET_STATE))
    colnames(clean_data_home) <- c("OUTLET_NAME",
                                   "HOURS_OPEN",
                                   "HOURS_CLOSE",
                                   "STATE")
    write.csv(x = clean_data_home, file = "./data/clean/clean_data_miltime.csv", na = "NaN", row.names = FALSE)
}

export_home()
