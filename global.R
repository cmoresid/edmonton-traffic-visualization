library(dplyr)
library(data.table)
library(stringr)

sites <- fread("data/sites.csv", stringsAsFactors = FALSE, header = TRUE)
sites$latitude <- as.double(sites$latitude)
sites$longitude <- as.double(sites$longitude)
sites$adt <- as.integer(sites$adt)
sites$address <- sapply(sites$address,str_trim)

all_sites <- sites %>%
    select(
        SiteID = site_id,
        Address = address,
        Latitude = latitude,
        Longitude = longitude,
        AverageDailyTraffic = adt,
        StreetType = street_type,
        PrimaryPurpose = primary_purpose
    )