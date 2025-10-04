##########
# Script to get and save Utah crash data for from Numetric
# https://udot.aashtowaresafety.com/crash-query#/raw-table
# YEAR == 2017 to 2023
# Default columns + Unrestrained Involved + Pedestrian Involved + Bicyclist Involved + Latitude + Longitude

##########
# Load data

# Load data
mydf <- read.csv(file=file.path("Data safety", "UtahCrashes.csv"), stringsAsFactors=F)

# Inspect
str(mydf)
# summary(mydf)

##########
# Adjust rows

# Filter by route
table(nchar(mydf$Full.Route.Name))
mydf <- mydf[nchar(mydf$Full.Route.Name)==5,]

# Filter by missing lat/lon
mydf <- mydf[!is.na(mydf$Latitude) & !is.na(mydf$Longitude),]

##########
# Adjust columns

# Crash.ID
summary(mydf$Crash.ID)

# Crash.Date.Time
names(mydf)[which(names(mydf)=="Crash.Date.Time")] <- "Date.Time"
# ?strptime 
head(mydf$Date.Time) # 12/31/2019 01:30 PM
mydf$Date.Time <- as.POSIXct(mydf$Date.Time, format="%m/%e/%Y %I:%M %p", tz="America/Denver")
summary(mydf$Date.Time)

# Year
table(mydf$Year)

# Full.Route.Name
sort(table(mydf$Full.Route.Name), decreasing=T)[1:100] # most frequent 100
head(sort(unique(mydf$Full.Route.Name)),1000)
tail(sort(unique(mydf$Full.Route.Name)),1000)

# Milepoint
summary(mydf$Milepoint)

# Crash.Severity
table(mydf$Crash.Severity)
mylevels <- c("No injury/PDO", "Possible injury", "Suspected Minor Injury", "Suspected Serious Injury", "Fatal")
mydf$Crash.Severity <- ordered(mydf$Crash.Severity, levels=mylevels)
rm(mylevels)
summary(mydf$Crash.Severity)

# Manner.of.Collision
table(mydf$Manner.of.Collision)
mydf$Manner.of.Collision <- ifelse(mydf$Manner.of.Collision %in% c("", "Other*", "Unknown"), "Unknown/Other", mydf$Manner.of.Collision)
mydf$Manner.of.Collision <- factor(mydf$Manner.of.Collision)
mydf$Manner.of.Collision <- relevel(mydf$Manner.of.Collision, ref="Not Applicable/Single Vehicle")
summary(mydf$Manner.of.Collision)

# Roadway.Junction.Type
names(mydf)[which(names(mydf)=="Roadway.Junction.Type.")] <- "Roadway.Junction.Type"
table(mydf$Roadway.Junction.Type)
mydf$Roadway.Junction.Type <- ifelse(mydf$Roadway.Junction.Type %in% c("", "89", "Other*", "Unknown"), "Unknown/Other", mydf$Roadway.Junction.Type)
mydf$Roadway.Junction.Type <- factor(mydf$Roadway.Junction.Type)
mydf$Roadway.Junction.Type <- relevel(mydf$Roadway.Junction.Type, ref="No Special Feature/Junction")
summary(mydf$Roadway.Junction.Type)

# Light.Condition
table(mydf$Light.Condition)
mydf$Light.Condition <- ifelse(mydf$Light.Condition %in% c("", "Other", "Unknown"), "Unknown/Other", mydf$Light.Condition)
mydf$Light.Condition <- factor(mydf$Light.Condition)
mydf$Light.Condition <- relevel(mydf$Light.Condition, ref="Daylight")
summary(mydf$Light.Condition)

# Weather.Condition
table(mydf$Weather.Condition)
mydf$Weather.Condition <- ifelse(mydf$Weather.Condition %in% c("", "Other", "Unknown"), "Unknown/Other", mydf$Weather.Condition)
mydf$Weather.Condition <- factor(mydf$Weather.Condition)
mydf$Weather.Condition <- relevel(mydf$Weather.Condition, ref="Clear")
summary(mydf$Weather.Condition)

# Roadway.Surface.Condition
table(mydf$Roadway.Surface.Condition)
mydf$Roadway.Surface.Condition <- ifelse(mydf$Roadway.Surface.Condition %in% c("", "Other*", "Unknown"), "Unknown/Other", mydf$Roadway.Surface.Condition)
mydf$Roadway.Surface.Condition <- factor(mydf$Roadway.Surface.Condition)
mydf$Roadway.Surface.Condition <- relevel(mydf$Roadway.Surface.Condition, ref="Dry")
summary(mydf$Roadway.Surface.Condition)

# Number.of.Vehicles.Involved
table(mydf$Number.of.Vehicles.Involved)

# Route.Type
table(mydf$Route.Type)
mydf$Route.Type <- factor(mydf$Route.Type, levels=c("Federal", "State", "Local"))
summary(mydf$Route.Type)

# Crash.Verified
table(mydf$Crash.Verified)
mydf$Crash.Verified <- ifelse(mydf$Crash.Verified=="true", T, F)
summary(mydf$Crash.Verified)

# Unrestrained.Involved
table(mydf$Unrestrained.Involved)
mydf$Unrestrained.Involved <- ifelse(mydf$Unrestrained.Involved=="Y", T, 
                              ifelse(mydf$Unrestrained.Involved=="N", F, NA))
summary(mydf$Unrestrained.Involved)

# Pedestrian.Involved
table(mydf$Pedestrian.Involved)
mydf$Pedestrian.Involved <- ifelse(mydf$Pedestrian.Involved=="Y", T, 
                            ifelse(mydf$Pedestrian.Involved=="N", F, NA))
summary(mydf$Pedestrian.Involved)

# Bicycle.Involved
table(mydf$Bicycle.Involved)
mydf$Bicycle.Involved <- ifelse(mydf$Bicycle.Involved=="Y", T, 
                         ifelse(mydf$Bicycle.Involved=="N", F, NA))
summary(mydf$Bicycle.Involved)

# Latitude
summary(mydf$Latitude)

# Longitude
summary(mydf$Longitude)

##########
# Finish

# Inspect
str(mydf)
summary(mydf)

# Save
saveRDS(mydf, file=file.path("Data safety", "crashes.rds"))
write.csv(mydf, file=file.path("Data safety", "crashes.csv"), row.names=F)

# Cleanup
rm(mydf)
gc()

# END
##########