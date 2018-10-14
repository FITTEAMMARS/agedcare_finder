# takes a string argument, outputs a vector with latitude and longitude of address

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