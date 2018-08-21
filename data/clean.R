# Packages used ---------

library(xlsx)
setwd("C:/Users/Nish/Documents/5120/agedcare_finder/data/")
ac1 <- read.csv("./Aged-Care-Homes-June-2018.csv")
ac2 <- read.csv("./HCP-June-2018.csv")

dim(ac1)
dim(ac2)

# Removing unecessary variables -----------

# what do these X ones even do? 
ac2$X <- NULL
ac2$X.1 <- NULL
ac2$X.3 <- NULL
ac2$X.4 <- NULL

#
ac2$MAX_EXIT_AMOUNT <- NULL


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
create_address_string <- function(row_number){
  row <- aged_care[row_number,]
  out <- paste(row$BUS_ST_ADDRESS, row$BUS_SUBURB, row$BUS_PCODE, sep = "")
  return(out)
}
