# Packages used ---------

library(tm)
library(stringr)
library(tidyverse)
library(tidytext)
library(reshape2)


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
ach$STREET_STATE <- factor(ach$STREET_STATE)
# All suburbs as CAPS
ach$STREET_SUBURB <- toupper(as.character(ach$STREET_SUBURB))

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

# Dementia and other specialised services
dem <- as.character(logical(length = nrow(ach)))
reable <- as.character(logical(length = nrow(ach)))
respite <- as.character(logical(length = nrow(ach)))
terminal <- as.character(logical(length = nrow(ach)))
mental_h <- as.character(logical(length = nrow(ach)))

for (f in 1:length(ach$SPECIALISED_SERVICES)) {
    serv <- ach$SPECIALISED_SERVICES[f]
    if (grepl(x = serv, pattern = "dementia", ignore.case = TRUE)) {
        dem[f] = "dementia"
    }
    if (grepl(x = serv, pattern = "reablement", ignore.case = TRUE)){
        reable[f] = "reablement"
    }
    if (grepl(x = serv, pattern = "respite", ignore.case = TRUE)){
        respite[f] = "respite"
    }  
    if (grepl(x = serv, pattern = "terminal", ignore.case = TRUE)){
        terminal[f] = "terminal"
    }  
    if (grepl(x = serv, pattern = "mental", ignore.case = TRUE)){
        mental_h[f] = "mental"
    }  
}
ach$dementia <- dem
ach$reable <- reable
ach$respite <- respite
ach$terminal <- terminal
ach$mental_health  <- mental_h

attr <- ach[!duplicated(ach$OUTLET_NAME),] 
attr$address <- paste(attr$STREET_ST_ADDRESS, attr$STREET_SUBURB, attr$STREET_PCODE, attr$STREET_STATE, sep = ", ")

## OUTLET_NAME cleaning --------------

# remove state strings from name
remove_state_string <- function(state_string){
    regex_s = paste("(?<=\\W|^)(?i)", state_string, "(?=\\W|$)", sep = "")
    out_str_v <- unlist(
        lapply(
            X = attr$OUTLET_NAME,
            FUN = gsub,
            pattern = regex_s,
            replacement = "",
            ignore.case = TRUE,
            perl = TRUE
        )
    )
    return(out_str_v)
}

# Floor -> Level for consistency

attr$address <- unlist(lapply(X = attr$address,
                              FUN = gsub,
                              pattern = "(?<=\\W)(?i)level\\W*(?=\\s\\W*)",
                              replacement = "Floor",
                              perl = TRUE))

# "rd" with Road
attr$address <- unlist(lapply(X = attr$address,
                              FUN = gsub,
                              pattern = "(?<=\\W)(?i)rd\\W*(?=\\s\\W*)",
                              replacement = "Road",
                              perl = TRUE))


# "st" with Street
attr$address <- unlist(lapply(X = attr$address,
                              FUN = gsub,
                              pattern = "(?<=\\W)(?i)st\\W*(?=\\s\\W*)",
                              replacement = "Street",
                              perl = TRUE))


attr$OUTLET_NAME <- remove_state_string("vic")
attr$OUTLET_NAME <- remove_state_string("nsw")
attr$OUTLET_NAME <- remove_state_string("sa")
attr$OUTLET_NAME <- remove_state_string("qld")
attr$OUTLET_NAME <- remove_state_string("act")
attr$OUTLET_NAME <- remove_state_string("tas")
attr$OUTLET_NAME <- remove_state_string("nt")
attr$OUTLET_NAME <- remove_state_string("wa")

# remove phone numbers
attr$OUTLET_NAME <- unlist(lapply(X = attr$OUTLET_NAME,
                                  FUN = gsub,
                                  pattern = "\\d+",
                                  replacement = "",
                                  perl = TRUE))


# remove space followed by "-"
attr$OUTLET_NAME <- unlist(lapply(X = attr$OUTLET_NAME,
                                  FUN = gsub,
                                  pattern = "^\\s*-\\W",
                                  replacement = "",
                                  perl = TRUE))



# remove "-" followed by spaces
attr$OUTLET_NAME <- unlist(lapply(X = attr$OUTLET_NAME,
                                  FUN = gsub,
                                  pattern = "\\W-\\s*$",
                                  replacement = "",
                                  perl = TRUE))


# remove empty brackets
attr$OUTLET_NAME <- unlist(lapply(X = attr$OUTLET_NAME,
                                  FUN = gsub,
                                  pattern = "\\(\\W*\\)",
                                  replacement = "",
                                  perl = TRUE))

# level mention



# starting spaces
attr$OUTLET_NAME <- unlist(lapply(X = attr$OUTLET_NAME,
                                  FUN = gsub,
                                  pattern = "^\\s*",
                                  replacement = "",
                                  perl = TRUE))





attr <- attr[!duplicated(attr$address),]

# one offs
ach[ach$id == 94,]$OUTLET_NAME = "365 Care"

## Remove punctuation from outlet name 

attr$OUTLET_NAME <- removePunctuation(attr$OUTLET_NAME)

# remove other special char
attr$OUTLET_NAME <- unlist(lapply(X = attr$OUTLET_NAME,
                                  FUN = gsub,
                                  pattern = "(?=\\W)(?=\\S)\\W",
                                  replacement = " ",
                                  perl = TRUE))




# remove doulbe spaces
attr$OUTLET_NAME <- unlist(lapply(X = attr$OUTLET_NAME,
                                  FUN = gsub,
                                  pattern = "\\s\\s+",
                                  replacement = " ",
                                  perl = TRUE))


attr$MAIN_PHONE <- as.character(attr$MAIN_PHONE)
attr$STREET_ST_ADDRESS <- as.character(attr$STREET_ST_ADDRESS)


# adress from individual observations
create_address_string <- function(row_number, data_set){
    row <- data_set[row_number,]
    row_street <- gsub(pattern = "\\s", replacement = "+", x = tolower(row$STREET_ST_ADDRESS), perl = TRUE)
    row_state <- as.character(row$STREET_STATE)
    row_pcode <- as.character(row$STREET_PCODE)
    row_suburb <- as.character(row$STREET_SUBURB)
    out <- paste(row_street, row_suburb, row_state, row_pcode, sep = ",+")
    return(out)
}



# AUX Functions -----------
# get lat/lng from string address 

address_code <- function(address){
    library(RJSONIO)
    url <- "https://maps.googleapis.com/maps/api/geocode/json?address="
    url <- URLencode(paste(url, address, "&key=", api_key, "&sensor=false", sep = ""))
    test <- fromJSON(url, simplify = FALSE)
    if (test$status == "OK"){
        out <- c(test$results[[1]]$geometry$location[[1]],
                 test$results[[1]]$geometry$location[[2]])
    }
    else{
        out <- NA
    }
    Sys.sleep(0.2)
    return(out)
    
}


if(sum(lat_v) == 0){
    lat_v <- numeric(length = nrow(attr))
    lng_v <- numeric(length = nrow(attr))
    
    for(ff in 1:nrow(attr)){
        gcode <- address_code(create_address_string(ff, attr))
        lat_v[ff] <- gcode[1]
        lng_v[ff] <- gcode[2]
    }
}


attr$lat <- lat_v
attr$lng <- lng_v


## 
na_ix <- which(is.na(attr$lat) & is.na(attr$lng))
strlist <- character(length = length(na_ix))

for(ix in na_ix){
    pos <- 1
    strlist[pos] <- paste(attr[ix,]$STREET_SUBURB, attr[ix,]$STREET_STATE, attr[ix,]$STREET_PCODE, sep = "+")
    attr$lat[ix] <- address_code(strlist[pos])[1]
    attr$lng[ix] <- address_code(strlist[pos])[2]
    pos <- pos + 1
}



attr_desc_rel <- attr %>%
    select(id, OUTLET_NAME, address, STREET_STATE, STREET_PCODE,
           STREET_SUBURB, OPEN_HOUR, CLOSE_HOUR, WEEKENDS, EVENINGS,
           dementia, reable, respite, terminal, mental_health,
           WEBSITE, MAIN_EMAIL, MAIN_PHONE, PUB_HOLIDAYS, DESCRIPTION,
           RELIGION, lat, lng) 




attr <- attr %>%
    select(id, OUTLET_NAME, address, STREET_STATE, STREET_PCODE,
           STREET_SUBURB, OPEN_HOUR, CLOSE_HOUR, WEEKENDS, EVENINGS,
           dementia, reable, respite, terminal, mental_health,
           WEBSITE, MAIN_EMAIL, MAIN_PHONE, PUB_HOLIDAYS, lat, lng) 


# OUTPUT ------------
attr$id <- c(1:nrow(attr))
write.csv(x = attr, file = "./data/clean/facility_basic.csv", na = "NaN", row.names = FALSE)
attr_desc_rel$id <- c(1:nrow(attr_desc_rel))

write.csv(x = attr_desc_rel, file = "./data/clean/facility_basic_desc_religion.csv", na = "NaN", row.names = FALSE)

# RES ------------

acr <- read.csv(file = "./data/clean/residential_basic.csv")



# Culture & Language ----------------

cult_df <- ach %>%
  select(id, CULTURE)
  
cult_df$CULTURE <- as.character(cult_df$CULTURE) %>%
  strsplit(",")

cult_df$CULTURE <- lapply(X = cult_df$CULTURE, FUN = gsub, pattern = "^\\s|\\s$", replacement = "")





# string AM/PM to 24h time 

to_24h <- function(time_string){
    return("pass")
}


zz <- fromJSON(URLdecode("https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyDCo-t-YzgmFHUVz7zgyBG7qRWlXBwW5fk
"))
