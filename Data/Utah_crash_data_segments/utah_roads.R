##########
# Script to get and save Utah road segment data from UGRC
# https://opendata.gis.utah.gov/datasets/utah-roads/about

library("sf")
library("mapview")

##########
# Load data

# Load data
Roads <- st_read(dsn=file.path("Data safety", "UtahRoads"), layer="Roads", stringsAsFactors=F)

# Change crs
st_crs(Roads)
Roads <- st_transform(Roads, crs=26912)

# Remove z-dimension
Roads$geometry
Roads <- st_zm(Roads)

# Inspect
str(Roads)
# summary(Roads)

##########
# Adjust rows

# Rename
roads <- Roads

# Filter for regular state routes only
roads <- roads[!is.na(roads$DOT_RTNAME),]
roads <- roads[!is.na(roads$DOT_HWYNAM),]
roads <- roads[nchar(roads$DOT_RTNAME)==5,]
roads <- roads[roads$CARTOCODE!=6,]

# Inspect
sort(table(roads$DOT_RTNAME), decreasing=T)[1:100]

##########
# Adjust columns

# Remove unnecessary columns
dc <- c("FROMADDR_L", "TOADDR_L", "FROMADDR_R", "TOADDR_R", "PARITY_L", "PARITY_R", 
        "PREDIR", "NAME", "POSTTYPE", "POSTDIR", "AN_NAME", "AN_POSTDIR", 
        "A1_PREDIR", "A1_NAME", "A1_POSTTYP", "A1_POSTDIR", 
        "A2_PREDIR", "A2_NAME", "A2_POSTTYP", "A2_POSTDIR", 
        "QUADRANT_L", "QUADRANT_R", "STATE_L", "STATE_R", "COUNTY_L", "COUNTY_R", 
        "ADDRSYS_L", "ADDRSYS_R", "POSTCOMM_L", "POSTCOMM_R", "ZIPCODE_L", "ZIPCODE_R", 
        "INCMUNI_L", "INCMUNI_R", "UNINCCOM_L", "UNINCCOM_R" ,"NBRHDCOM_L", "NBRHDCOM_R", 
        "ER_CAD_ZON", "ESN_L", "ESN_R", "MSAGCOMM_L", "MSAGCOMM_R", 
        "LOCAL_UID", "UTAHRD_UID", "SOURCE", "UPDATED", "EFFECTIVE", "EXPIRE", 
        "CREATED", "CREATOR", "EDITOR", "CUSTOMTAGS")
cd <- c("STATUS", "ACCESSCODE", "DOT_RTPART", "DOT_FCLASS", "DOT_SRFTYP", "DOT_CLASS", 
        "DOT_AADT", "DOT_AADTYR", "DOT_OWN_L", "DOT_OWN_R", "DOT_THRULA", "TDMNET_L", "TDMNET_R", 
        "PED_L", "PED_R", "BIKE_L", "BIKE_R", "BIKE_PLN_L", "BIKE_PLN_R", "BIKE_REGPR", "BIKE_NOTES")
roads[,c(dc, cd)] <- NULL
rm(dc, cd)

# Visualize
mapview(roads)

# Format columns
# see Road Centerlines Data Model: 
# https://docs.google.com/spreadsheets/d/1jQ_JuRIEtzxj60F0FAGmdu5JrFpfYBbSt3YzzCjxpfI/edit?gid=811360546#gid=811360546
# CARTOCODE
table(roads$CARTOCODE)
roads$CARTOCODE <- factor(roads$CARTOCODE, levels=c(1:5), 
                          labels=c("1 Interstates", "2 US Highways, Separated", "3 US Highways, Unseparated", "4 Major State Highways, Separated", "5 Major State Highways, Unseparated"))
summary(roads$CARTOCODE)
# FULLNAME
sort(table(roads$FULLNAME), decreasing=T)[1:25]
# ONEWAY
table(roads$ONEWAY)
roads$ONEWAY <- factor(roads$ONEWAY, levels=c(0,1,2), labels=c("Two-way", "One-way", "One-way"))
summary(roads$ONEWAY)
# VERT_LEVEL
table(roads$VERT_LEVEL)
roads$VERT_LEVEL <- factor(roads$VERT_LEVEL, levels=c(0,1,2), labels=c("Ground", "Overpass", "Overpass"))
summary(roads$VERT_LEVEL)
# SPEED_LMT
table(roads$SPEED_LMT)
# DOT_HWYNAM
sort(table(roads$DOT_HWYNAM), decreasing=T)[1:25]
# DOT_RTNAME
sort(table(roads$DOT_RTNAME), decreasing=T)[1:25]
# DOT_RTPART
table(roads$DOT_RTPART)
# DOT_F_MILE, DOT_T_MILE
summary(roads$DOT_F_MILE)
summary(roads$DOT_T_MILE)
table(roads$DOT_F_MILE <= roads$DOT_T_MILE)
roads$F_OR_T <- ifelse(roads$DOT_F_MILE <= roads$DOT_T_MILE, "F", 
                ifelse(roads$DOT_T_MILE < roads$DOT_F_MILE, "T", NA))
roads$MP_BEG <- ifelse(roads$F_OR_T=="F", roads$DOT_F_MILE, 
                ifelse(roads$F_OR_T=="T", roads$DOT_T_MILE, NA))
roads$MP_END <- ifelse(roads$F_OR_T=="F", roads$DOT_T_MILE, 
                ifelse(roads$F_OR_T=="T", roads$DOT_F_MILE, NA))
table(roads$MP_BEG <= roads$MP_END)
table(table(roads$DOT_RTNAME[roads$MP_BEG==0]))
table(table(roads$DOT_RTNAME[roads$MP_END==0]))
# ... still some issues with missing MPs, but okay for now
# UNIQUE_ID, GlobalID
sort(table(roads$UNIQUE_ID), decreasing=T)[1:25]
sort(table(roads$GlobalID), decreasing=T)[1:25]

# Reorganize columns
roads <- roads[,c("GlobalID", "UNIQUE_ID", "FULLNAME", "DOT_HWYNAM", "DOT_RTNAME", "MP_BEG", "MP_END", 
                  "CARTOCODE", "ONEWAY", "VERT_LEVEL", "SPEED_LMT")]

##########
# Finish

# Drop geometry
temp <- st_drop_geometry(roads)

# Inspect
str(roads)
summary(roads)

# Save
saveRDS(roads, file=file.path("Data safety", "roads.rds"))
write.csv(temp, file=file.path("Data safety", "roads.csv"), row.names=F)

# Cleanup
rm(roads, temp)
rm(Roads)
gc()

# END
##########