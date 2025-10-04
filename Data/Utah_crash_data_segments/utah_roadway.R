# Script to get and save Utah roadway data

library("sf")
library("mapview")

# Speed limit
# load data
speed <- st_read(dsn=file.path("Data safety", "UDOT_Speed_Limits_(2021)"), layer="UDOT_Speed_Limits_(2021)", stringsAsFactors=F)
# change crs
st_crs(speed)
# speed <- st_transform(speed, crs=26912)
# remove z-dimension
speed$geometry
speed <- st_zm(speed)
# inspect
str(speed)
# adjust columns
# save
saveRDS(speed, file.path("Data safety", "speedshp.rds"))
# cleanup
rm(speed)
gc()

# Functional class
# load data
fclass <- st_read(dsn=file.path("Data safety", "Functional_Class"), layer="Functional_Class", stringsAsFactors=F)
# change crs
st_crs(fclass)
# fclass <- st_transform(fclass, crs=26912)
# remove z-dimension
fclass$geometry
fclass <- st_zm(fclass)
# inspect
str(fclass)
# adjust columns
# save
saveRDS(fclass, file.path("Data safety", "fclassshp.rds"))
# cleanup
rm(fclass)
gc()

# Lanes
# load data
lanes <- st_read(dsn=file.path("Data safety", "Lanes"), layer="Lanes", stringsAsFactors=F)
# change crs
st_crs(lanes)
lanes <- st_transform(lanes, crs=26912)
# remove z-dimension
lanes$geometry
lanes <- st_zm(lanes)
# inspect
str(lanes)
# adjust columns
# save
saveRDS(lanes, file.path("Data safety", "lanesshp.rds"))
# cleanup
rm(lanes)
gc()

# Urban areas
# load data
urban <- st_read(dsn=file.path("Data safety", "UrbanAreasCensus2020"), layer="UrbanAreasCensus2020", stringsAsFactors=F)
# change crs
st_crs(urban)
urban <- st_transform(urban, crs=26912)
# remove z-dimension
urban$geometry
urban <- st_zm(urban)
# inspect
str(urban)
# adjust columns
# save
saveRDS(urban, file.path("Data safety", "urbanshp.rds"))
# cleanup
rm(urban)
gc()

# END