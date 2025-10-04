# Script to get and save Utah AADT data

# Load spatial package "sf: Simple Features for R"
library("sf")

# Load data
aadt_rounded <- st_read(dsn=file.path("Data safety", "AADT_Rounded"), layer="AADT_Rounded", stringsAsFactors=F)
aadt_unrounded <- st_read(dsn=file.path("Data safety", "AADT_Unrounded"), layer="AADT_Unrounded", stringsAsFactors=F)

# Inspect
summary(aadt_rounded)
summary(aadt_unrounded)

# Select dataset
mydf <- aadt_rounded
# mydf <- aadt_unrounded

# Check/edit coordinate reference system
st_crs(mydf)
# mydf <- st_transform(mydf, crs=26912) # NAD83 / UTM zone 12N https://epsg.io/26912

# Remove z-dimension
mydf$geometry
mydf <- st_zm(mydf)

# Inspect
str(mydf)

# Adjust some column types
# need to create just a data.frame (no spatial)
temp <- st_drop_geometry(mydf)

# Adjust some TRK columns
str(temp)
# convert data types
for (j in names(temp)[grepl("TRK", names(temp))]) {
  temp[,j] <- as.numeric(temp[,j])
}; rm(j)
str(temp)

# Adjust RT_Type
table(temp$RT_Type)
temp$RT_Type <- factor(temp$RT_Type, levels=c("FA", "State Route", "Interstate"))

# Reattach data.frame to spatial
mydf[,names(temp)] <- temp
str(mydf)

# Save
saveRDS(mydf, file.path("Data safety", "aadtshp.rds"))
write.csv(temp, file=file.path("Data safety", "aadtshp.csv"), row.names=F)
st_write(mydf, dsn=file.path("Data safety", "aadtshp"), layer="aadtshp.shp", driver="ESRI Shapefile")

# Cleanup
rm(mydf, temp, aadt_rounded, aadt_unrounded)
gc()

# END