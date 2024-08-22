########################################
# Project:  MPC-559 Travel behavior air quality
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
# File:     tbaqsurvey.R
# Date:     2024 Fall
# About:    Prep TB-AQ survey data for class tutorials
########################################

########################################
# Notes

# Open R project first, then open this R script

# Load packages
# (install first if haven't on your computer)
library("fastDummies")

########################################
# Load data

# Load data
mainurl <- "https://raw.github.com/singletonpa/2019-winter-transportation-survey/main/Data/Survey%202019%20Winter/Data%204%20Anonymized/"
HH <- readRDS(file=url(paste0(mainurl, "HH.rds"), method="libcurl"))
PER <- readRDS(file=url(paste0(mainurl, "PER.rds"), method="libcurl"))
VEH <- readRDS(file=url(paste0(mainurl, "VEH.rds"), method="libcurl"))
DIARY <- readRDS(file=url(paste0(mainurl, "DIARY.rds"), method="libcurl"))
PLACE <- readRDS(file=url(paste0(mainurl, "PLACE.rds"), method="libcurl"))
TRIP <- readRDS(file=url(paste0(mainurl, "TRIP.rds"), method="libcurl"))
PER_final <- readRDS(file=url(paste0(mainurl, "PER_final.rds"), method="libcurl"))
rm(mainurl)

# Remove rows
table(DIARY$REMOVE)
trid <- DIARY$ResponseId[DIARY$REMOVE!=""]
diary <- DIARY[!(DIARY$ResponseId %in% trid),]
place <- PLACE[!(PLACE$ResponseId %in% trid),]
trip <- TRIP[!(TRIP$ResponseId %in% trid),]
rm(trid)

########################################
# Select dependent variables

# Categorize places by activity
summary(place$ACTIVITY)
# 1. Mandatory
act1 <-  c("Work activities", 
           "School activities", 
           "Work- or school-related activities")
place$ACT_MAND <- place$ACTIVITY %in% act1
# 2. Middle category (semi-mandatory, semi-discretionary)
act2 <- c("Civic or religious activities", 
          "Drop off or pick up passenger(s)", 
          "Other errands or appointments (bank, professional office, doctor/dentist, etc.)", 
          "Service private vehicle (gas, oil, repairs, etc.)")
place$ACT_SEMI <- place$ACTIVITY %in% act2
# 3. Discretionary
act3 <- c("Eat meal at restaurant", 
          "Social or entertainment activities (friends/relatives, movie, etc.)", 
          "Outdoor or indoor exercise (sports, jogging, bicycling, walking dog, gym, etc.)", 
          "Shopping (groceries, clothing, convenience store, etc)")
place$ACT_DISC <- place$ACTIVITY %in% act3
# aggregate
temp1 <- aggregate(cbind(ACT_MAND, ACT_SEMI, ACT_DISC) ~ HHCODE + PERCODE + DATE, data=place, FUN=sum)
temp1$ACT_TOT <- temp1$ACT_MAND + temp1$ACT_SEMI + temp1$ACT_DISC
# remove
rm(act1, act2, act3)

# Categorize trips by mode
summary(trip$MODE)
# 1. Active
mode1 <- c("Walk", "Bicycle")
trip$MODE_ACT <- trip$MODE %in% mode1
# 2. Public
mode2 <- c("School Bus", "Local Bus (CVTD or Aggie Shuttle)")
trip$MODE_PUB <- trip$MODE %in% mode2
# 3. Private
mode3 <- c("Car/Van/Truck/SUV Driver", "Car/Van/Truck/SUV Passenger", "Motorcycle/Scooter/Moped")
trip$MODE_PRI <- trip$MODE %in% mode3
# aggregate
temp2 <- aggregate(cbind(MODE_ACT, MODE_PUB, MODE_PRI) ~ HHCODE + PERCODE + DATE, data=trip, FUN=sum)
temp2$MODE_TOT <- temp2$MODE_ACT + temp2$MODE_PUB + temp2$MODE_PRI
# remove
rm(mode1, mode2, mode3)

# Categorize travel distance by mode
# travel distance
trip$DIST_ACT <- trip$DIST * trip$MODE_ACT
trip$DIST_PUB <- trip$DIST * trip$MODE_PUB
trip$DIST_PRI <- trip$DIST * trip$MODE_PRI
# aggregate
temp3 <- aggregate(cbind(DIST_ACT, DIST_PUB, DIST_PRI) ~ HHCODE + PERCODE + DATE, data=trip, FUN=sum)
temp3$DIST_TOT <- temp3$DIST_ACT + temp3$DIST_PUB + temp3$DIST_PRI

# Categorize travel time by mode
# travel time
trip$TIME_ACT <- trip$TRIP_TIME * trip$MODE_ACT
trip$TIME_PUB <- trip$TRIP_TIME * trip$MODE_PUB
trip$TIME_PRI <- trip$TRIP_TIME * trip$MODE_PRI
# aggregate
temp4 <- aggregate(cbind(TIME_ACT, TIME_PUB, TIME_PRI) ~ HHCODE + PERCODE + DATE, data=trip, FUN=sum)
temp4$TIME_TOT <- temp4$TIME_ACT + temp4$TIME_PUB + temp4$TIME_PRI

# Leave home or not
temp5 <- aggregate(cbind(I(LEAVE=="No" & PLANO==1)) ~ HHCODE + PERCODE + DATE, data=place, FUN=sum)
names(temp5)[which(names(temp5)=="V1")] <- "STAYHOME"
temp5$STAYHOME <- as.logical(temp5$STAYHOME)

# Merge aggregations
mydf <- merge(temp1, temp2, by=c("HHCODE", "PERCODE", "DATE"), all=T)
mydf <- merge(mydf, temp3, by=c("HHCODE", "PERCODE", "DATE"), all=T)
mydf <- merge(mydf, temp4, by=c("HHCODE", "PERCODE", "DATE"), all=T)
mydf <- merge(mydf, temp5, by=c("HHCODE", "PERCODE", "DATE"), all=T)
rm(temp1, temp2, temp3, temp4, temp5)

# Inspect
table(mydf$STAYHOME, mydf$ACT_TOT==0)
table(mydf$STAYHOME, is.na(mydf$MODE_TOT))
table(mydf$STAYHOME, is.na(mydf$DIST_TOT))
table(mydf$STAYHOME, is.na(mydf$TIME_TOT))
mydf[mydf$STAYHOME==T,c("ACT_TOT", "ACT_MAND", "ACT_SEMI", "ACT_DISC")] <- NA
table(mydf$STAYHOME, is.na(mydf$ACT_TOT))

# Fix NAs
mydf$num_nas <- rowSums(is.na(mydf))
table(mydf$num_nas)
table(mydf$STAYHOME, mydf$num_nas)
# mydf[mydf$num_nas==4,]  #  4 = distance error (remove)
# mydf[mydf$num_nas==16,] # 16 = no travel (replace with 0)
# for (i in 1:nrow(mydf)) {
#   if (mydf[i,"num_nas"] == 16) {
#     mydf[i,][is.na(mydf[i,])] <- 0L
#   }
# }; rm(i)
mydf <- mydf[mydf$num_nas!=4,]
row.names(mydf) <- NULL
mydf$num_nas <- NULL

# Inspect, adjust for modes
# no mode use
mydf$NOMO_ACT <- mydf$MODE_ACT==0
mydf$NOMO_PUB <- mydf$MODE_PUB==0
mydf$NOMO_PRI <- mydf$MODE_PRI==0
# check
table(mydf$NOMO_ACT, mydf$DIST_ACT==0)
table(mydf$NOMO_ACT, mydf$TIME_ACT==0)
table(mydf$NOMO_PUB, mydf$DIST_PUB==0)
table(mydf$NOMO_PUB, mydf$TIME_PUB==0)
table(mydf$NOMO_PRI, mydf$DIST_PRI==0)
table(mydf$NOMO_PRI, mydf$TIME_PRI==0)
# fix NAs
mydf[!is.na(mydf$NOMO_ACT) & mydf$NOMO_ACT==T, c("MODE_ACT", "DIST_ACT", "TIME_ACT")] <- NA
mydf[!is.na(mydf$NOMO_PUB) & mydf$NOMO_PUB==T, c("MODE_PUB", "DIST_PUB", "TIME_PUB")] <- NA
mydf[!is.na(mydf$NOMO_PRI) & mydf$NOMO_PRI==T, c("MODE_PRI", "DIST_PRI", "TIME_PRI")] <- NA
# check
table(mydf$NOMO_ACT, is.na(mydf$DIST_ACT))
table(mydf$NOMO_ACT, is.na(mydf$TIME_ACT))
table(mydf$NOMO_PUB, is.na(mydf$DIST_PUB))
table(mydf$NOMO_PUB, is.na(mydf$TIME_PUB))
table(mydf$NOMO_PRI, is.na(mydf$DIST_PRI))
table(mydf$NOMO_PRI, is.na(mydf$TIME_PRI))

# Inspect DVs
mydvs <- c("ACT_TOT",  "ACT_MAND", "ACT_SEMI", "ACT_DISC", 
           "MODE_TOT", "MODE_ACT", "MODE_PUB", "MODE_PRI", 
           "DIST_TOT", "DIST_ACT", "DIST_PUB", "DIST_PRI", 
           "TIME_TOT", "TIME_ACT", "TIME_PUB", "TIME_PRI", 
           "STAYHOME", "NOMO_ACT", "NOMO_PUB", "NOMO_PRI")
summary(mydf[,mydvs])

########################################
# Select independent variables

# Inspect
str(HH, list.len=ncol(HH))
str(PER, list.len=ncol(PER))
str(PER_final, list.len=ncol(PER_final))
str(diary, list.len=ncol(diary))

# Merge with HH, PER, PER_final, DIARY information
hh <- HH[,c("HHCODE", "HTYPE2", "HTENURE", "HHINC3", "HHKIDS2", "HHNPER", "HHBIKES2", "HHNVEH", "HLOC_GEOID")]
per <- PER[,c("HHCODE", "PERCODE", "AGE3", "RACE1", "GEND2", "EDUC3", "STUDENT2", "WORKER", "DRVLIC")]
perf <- PER_final[,c("HHCODE", "PERCODE")] # nothing for now
diary2 <- diary[,c("HHCODE", "PERCODE", "DATE", "RATE_TRAFFIC", "RATE_WEATHER", "RATE_AIRQUAL")]
# format
names(hh)[which(names(hh)=="HLOC_GEOID")] <- "GEOID10"
hh <- hh[!duplicated(hh),]
per <- per[!duplicated(per),]
perf <- perf[!duplicated(perf),]
diary2 <- diary2[!duplicated(diary2),]
# merge
mydf <- merge(mydf, hh, by=c("HHCODE"), all.x=T, all.y=F)
mydf <- merge(mydf, per, by=c("HHCODE", "PERCODE"), all.x=T, all.y=F)
mydf <- merge(mydf, perf, by=c("HHCODE", "PERCODE"), all.x=T, all.y=F)
mydf <- merge(mydf, diary2, by=c("HHCODE", "PERCODE", "DATE"), all.x=T, all.y=F)
# remove
rm(hh, per, perf, diary2)

# Reorganize mydf
mydf <- mydf[,c("HHCODE", "PERCODE", "DATE", "GEOID10", names(mydf)[4:ncol(mydf)])]
mydf <- mydf[order(mydf$HHCODE, mydf$PERCODE, mydf$DATE),]
rownames(mydf) <- NULL

# Inspect IVs
mydf$RATE_AIRQUAL2 <- as.integer(mydf$RATE_AIRQUAL)
myivs <- c("HTYPE2", "HTENURE", "HHINC3", "HHKIDS2", "HHNPER", "HHBIKES2", "HHNVEH", 
           "AGE3", "RACE1", "GEND2", "EDUC3", "STUDENT2", "WORKER", "DRVLIC")
summary(mydf[,myivs])

########################################
# Descriptive statistics

# Construct datasets for descriptive statistics
# DVs
mydf1 <- mydf[,mydvs]
mydf1a <- mydf1[,which(unlist(lapply(mydf1, class)) %in% c("integer", "numeric"))]
mydf1b <- mydf1[,which(unlist(lapply(mydf1, class)) %in% c("logical", "factor"))]
mydf1b <- as.data.frame(lapply(mydf1b, as.factor))
mydf1b <- dummy_cols(mydf1b, ignore_na=T, remove_selected_columns=T)
rm(mydf1)
# IVs
mydf2 <- mydf[,myivs]
mydf2a <- mydf2[,which(unlist(lapply(mydf2, class)) %in% c("integer", "numeric"))]
mydf2b <- mydf2[,which(unlist(lapply(mydf2, class)) %in% c("logical", "factor"))]
mydf2b <- dummy_cols(mydf2b, ignore_na=T, remove_selected_columns=T)
rm(mydf2)

# Calculate descriptive statistics
# initialize
tabdes <- data.frame(Type=character(), Var=character(), Freq=integer(), Perc=numeric(), Mean=numeric(), SD=numeric())
# calculate
for (i in names(mydf1a)) {
  td <- list("DV", i, NA, NA, mean(mydf1a[,i], na.rm=T), sd(mydf1a[,i], na.rm=T))
  tabdes <- rbind(tabdes, td); rm(td)
}; rm(i)
for (i in names(mydf1b)) {
  td <- list("DV", i, sum(mydf1b[,i], na.rm=T), 100 * sum(mydf1b[,i], na.rm=T) / nrow(mydf1b[!is.na(mydf1b[,i]),]), NA, NA)
  tabdes <- rbind(tabdes, td); rm(td)
}; rm(i)
for (i in names(mydf2a)) {
  td <- list("IV", i, NA, NA, mean(mydf2a[,i], na.rm=T), sd(mydf2a[,i], na.rm=T))
  tabdes <- rbind(tabdes, td); rm(td)
}; rm(i)
for (i in names(mydf2b)) {
  td <- list("IV", i, sum(mydf2b[,i], na.rm=T), 100 * sum(mydf2b[,i], na.rm=T) / nrow(mydf2b[!is.na(mydf2b[,i]),]), NA, NA)
  tabdes <- rbind(tabdes, td); rm(td)
}; rm(i)
# inspect
names(tabdes) <- c("Type", "Var", "Freq", "Perc", "Mean", "SD")
tabdes

# Calculate correlations
mydf1 <- cbind(mydf1a, mydf1b)
mydf2 <- cbind(mydf2a, mydf2b)
tabcor <- cor(mydf2, use="pairwise.complete.obs")
tabcor

# Remove
rm(mydf1, mydf1a, mydf1b, mydf2, mydf2a, mydf2b)
rm(tabdes, tabcor)
gc()

########################################
# Data preparation

# Select IVs
# - removed HTENURE b/c correlated (+0.78) w/ HTYPE2
# - removed DRVLIC b/c too skewed (<1%)
myivs2 <- c("HTYPE2", "HHINC3", "HHKIDS2", "HHNPER", "HHBIKES2", "HHNVEH", 
            "AGE3", "RACE1", "GEND2", "EDUC3", "STUDENT2", "WORKER")

# Remove cases with missing observations on DVs or IVs
# mydf2 <- mydf[,c(mydvs, myivs2)]
mydf2 <- mydf[,c("DATE", "HHCODE", "PERCODE", mydvs, myivs2)]
mydf2 <- mydf2[complete.cases(mydf2[,myivs2]),]
mydf2$ID <- paste(mydf2$HHCODE, mydf2$PERCODE, sep="_")

# Reorg columns
mydf2 <- mydf2[,c("ID", "HHCODE", "PERCODE", "DATE", names(mydf2)[4:35])]

########################################
# Save

# Save as rds and csv
saveRDS(mydf2, file.path("Data data", "tbaqsurvey.rds"))
write.csv(mydf2, file.path("Data data", "tbaqsurvey.csv"), row.names=F)

########################################
# Clean up

# Remove
rm(mydvs, myivs, myivs2)
rm(mydf, mydf2)
rm(diary, place, trip)
rm(HH, PER, VEH, DIARY, PLACE, TRIP, PER_final)
gc()

########################################
# END
########################################