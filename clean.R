# Packages used ---------

library(tm)
library(stringr)
library(tidyverse)
library(tidytext)
library(reshape2)


# aged care residential
#acr <- read.csv("./data/Aged-Care-Homes-June-2018.csv")
# aged care home
ach <- read.csv("./data/HCP-June-2018.csv", fileEncoding="UTF-8-BOM")
# Removing unecessary variables -----------

# what do these X ones even do? probably just errors from xlsx -> csv
ach$X <- NULL
ach$X.1 <- NULL
ach$X.2 <- NULL
ach$X.3 <- NULL
ach$X.4 <- NULL

# These aren't needed for our analysis
ach$MAX_EXIT_AMOUNT <- NULL
ach$COMMGOVT_SUBSIDISED <- NULL
ach$NOTICE_OF_NON_COMPLIANCE <- NULL
ach$HOME_CARE_LEVEL1_PROVIDED <- NULL
ach$HOME_CARE_LEVEL1_AVAILABILITY <- NULL
ach$HOME_CARE_LEVEL2_PROVIDED <- NULL
ach$HOME_CARE_LEVEL2_AVAILABILITY <- NULL
ach$HOME_CARE_LEVEL3_AVAILABILITY <- NULL
ach$HOME_CARE_LEVEL3_PROVIDED <- NULL
ach$HOME_CARE_LEVEL4_PROVIDED <- NULL
ach$HOME_CARE_LEVEL4_AVAILABILITY <- NULL
ach$NOTICE_OF_SANCTION <- NULL
ach$CASE_MANAGEMENT_PROVIDER <- NULL
ach$CASE_MANAGEMENT_SELF <- NULL
ach$AVE_24.7_SURCHARGE <- NULL
ach$AVE_EVENING_SURCHARGE <- NULL
ach$AVE_WEEKEND_SURCHARGE <- NULL
ach$AVE_PUBLIC_HOLIDAY_SURCHARGE <- NULL
ach$MAIN_FAX <- NULL

# remove blank obs and disclaimer row(s)
ach <- ach[1:4618,]

# basic ID for each facility
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

# Removing NaNs from WEEKEND/EVENINGS/PUB_HOLIDAYS
ach[ach$WEEKENDS == "",]$WEEKENDS = "Available"
ach[ach$EVENINGS == "",]$EVENINGS = "Available"
ach[ach$PUB_HOLIDAYS == "",]$PUB_HOLIDAYS = "Available"

ach$WEEKENDS <- factor(ach$WEEKENDS)
ach$EVENINGS <- factor(ach$EVENINGS)
ach$PUB_HOLIDAYS <- factor(ach$PUB_HOLIDAYS)

levels(ach$WEEKENDS) <- c(TRUE, FALSE)
levels(ach$EVENINGS) <- c(TRUE, FALSE)
levels(ach$PUB_HOLIDAYS) <- c(TRUE, FALSE)

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

serv_c <- Corpus(VectorSource(as.character(ach$SPECIALISED_SERVICES)))
serv_c <- tm_map(serv_c, removePunctuation)
serv_c <- tm_map(serv_c, tolower)
serv_c <- tm_map(serv_c, removeWords, stopwords("english"))
serv_tdm <- TermDocumentMatrix(serv_c)
top_serv <- rowSums(as.matrix(serv_tdm))
sort(top_serv, decreasing = TRUE)

# ng
ng <- ach %>%
    select(id, SPECIAL_NEEDS_GROUPS)

ng <- tidy(ng)
# Dementia
dem <- logical(length = nrow(ach))
reable <- logical(length = nrow(ach))
respite <- logical(length = nrow(ach))
terminal <- logical(length = nrow(ach))
mental_h <- logical(length = nrow(ach))

for (f in 1:length(ach$SPECIALISED_SERVICES)) {
    serv <- ach$SPECIALISED_SERVICES[f]
    if (grepl(x = serv, pattern = "Dementia")) {
        dem[f] = TRUE
    }
    if (grepl(x = serv, pattern = "Reablement")){
        reable[f] = TRUE
    }
    if (grepl(x = serv, pattern = "Respite")){
        respite[f] = TRUE
    }  
    if (grepl(x = serv, pattern = "Terminal")){
        terminal[f] = TRUE
    }  
    if (grepl(x = serv, pattern = "Mental")){
        mental_h[f] = TRUE
    }  
}





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

