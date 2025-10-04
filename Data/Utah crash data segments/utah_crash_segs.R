########################################
# Script to calculate Utah crash frequencies for segments
# and to get other roadway information about segments
# for crash data modeling and before/after analysis
########################################
# Prepare

library("sf")
library("mapview")

########################################
# Load data

# roads
roads <- readRDS(file=file.path("Data safety", "roads.rds"))

# urban
urban <- readRDS(file=file.path("Data safety", "urbanshp.rds"))

# fclass
fclass <- readRDS(file=file.path("Data safety", "fclassshp.rds"))

# speed
speed <- readRDS(file=file.path("Data safety", "speedshp.rds"))

# lanes
lanes <- readRDS(file=file.path("Data safety", "lanesshp.rds"))

# aadt
aadt <- readRDS(file=file.path("Data safety", "aadtshp.rds"))

# crashes
crashes <- readRDS(file=file.path("Data safety", "crashes.rds"))

# inspect
str(roads)
str(urban)
str(fclass)
str(speed)
str(lanes)
str(aadt)
str(crashes)

########################################
# Process data

# roads
# mapview(roads)
rts <- roads[,c("DOT_RTNAME", "MP_BEG", "MP_END")]
names(rts)[1] <- "ROUTE"
rts <- rts[order(rts$ROUTE, rts$MP_BEG, rts$MP_END),]
rts$DIST <- rts$MP_END - rts$MP_BEG
rts$LENG <- as.numeric(st_length(rts)/1609.344) # m to mi
rts$DIFF <- abs(rts$DIST - rts$LENG)
rts$PROP <- rts$DIFF / rts$LENG
rts$DIFFR <- round(rts$DIFF,1)
rts$PROPR <- round(rts$PROP,2)
# remove both zeros
rts <- rts[!(rts$MP_BEG==0 & rts$MP_END==0),]
# remove beg zeros AND prop > 1
rts <- rts[!(rts$MP_BEG==0 & rts$PROP>0.5),]
# View(rts[rts$MP_BEG==0 & rts$DIFFR>0,])
rts[c("LENG", "DIFF", "PROP", "DIFFR", "PROPR")] <- NULL

# urban
# mapview(urban)

# fclass
# filter cols
dat_fc <- st_drop_geometry(fclass)[c("route_id", "from_measu", "to_measure", "FUNCTIONAL")]
names(dat_fc) <- c("ROUTE", "MP_BEG", "MP_END", "FUNCLASS")
table(dat_fc$FUNCLASS)
dat_fc <- dat_fc[!grepl("Proposed", dat_fc$FUNCLASS),]
# filter rows
table(nchar(dat_fc$ROUTE))
dat_fc <- dat_fc[nchar(dat_fc$ROUTE)==6,]
sort(table(dat_fc$ROUTE), decreasing=T)[1:100] # most frequent 100
# adjust cols
table(substr(dat_fc$ROUTE,6,6))
dat_fc$ROUTE <- substr(dat_fc$ROUTE,1,5)
table(dat_fc$FUNCLASS)
table(dat_fc$MP_BEG <= dat_fc$MP_END)
# inspect
str(dat_fc)
summary(dat_fc)

# speed
# filter cols
dat_sp <- st_drop_geometry(speed)[c("Route", "Beg_MP", "End_MP", "Speed_Limi")]
names(dat_sp) <- c("ROUTE", "MP_BEG", "MP_END", "SPEEDLIM")
# filter rows
table(nchar(dat_sp$ROUTE))
sort(table(dat_sp$ROUTE), decreasing=T)[1:100] # most frequent 100
# adjust cols
table(substr(dat_sp$ROUTE,6,6))
dat_sp$ROUTE <- substr(dat_sp$ROUTE,1,5)
table(dat_sp$SPEEDLIM)
table(dat_sp$MP_BEG <= dat_sp$MP_END)
# inspect
str(dat_sp)
summary(dat_sp)

# lanes
# filter cols
dat_ln <- st_drop_geometry(lanes)[c("ROUTE", "START_ACCU", "END_ACCUM", "THRU_WDTH", 
                                    "OMS_LANES", "THRU_CNT", "L_TURN_CNT", "R_TURN_CNT", 
                                    "TWOWAY_CNT", "TWWY_MD_CT", 
                                    "ACCELL_CNT", "DECELL_CNT", "PASS_CNT", "AUX_CNT", 
                                    "HOV_CNT", "RAP_TRN_CT", "BIKE_CNT", "GRAVEL_CNT", "OTHER_CNT", 
                                    "LSHLDR_CNT", "RSHLDR_CNT", "PNT_ISL_CN", "RSD_ISL_CN")]
names(dat_ln) <- c("ROUTE", "MP_BEG", "MP_END", "LN_THRU_WIDTH", 
                   "LN_TOTAL", "LN_THRU", "LN_LTURN", "LN_RTURN", 
                   "LN_TWOWAY", "LN_TWMED", "LN_ACCEL", "LN_DECEL", "LN_PASS", "LN_AUX", 
                   "LN_HOV", "LN_TRAN", "LN_BIKE", "LN_GRAVEL", "LN_OTHER", 
                   "LN_LSHLDR", "LN_RSHLDR", "LN_ISLPNT", "LN_ISLRDS")
# filter rows
table(nchar(dat_ln$ROUTE))
dat_ln <- dat_ln[nchar(dat_ln$ROUTE)==5,]
sort(table(dat_ln$ROUTE), decreasing=T)[1:100] # most frequent 100
# adjust cols
table(dat_ln$MP_BEG <= dat_ln$MP_END)
# inspect
str(dat_ln)
summary(dat_ln)

# aadt
# filter cols
dat_dt <- st_drop_geometry(aadt)
dat_dt[,c("OBJECTID", "Station", "DESC_", "RT_NUM", "RT_Type", "Shape_Leng")] <- NULL
names(dat_dt)[1:3] <- c("ROUTE", "MP_BEG", "MP_END")
# filter rows
table(nchar(dat_dt$ROUTE))
# adjust cols
table(substr(dat_dt$ROUTE,6,6))
dat_dt$ROUTE <- substr(dat_dt$ROUTE,1,5)
table(dat_dt$MP_BEG <= dat_dt$MP_END)
# inspect
str(dat_dt)
summary(dat_dt)

# crashes
dat_cr <- crashes
# filter rows
table(dat_cr$Roadway.Junction.Type)
dat_cr <- subset(dat_cr, !(dat_cr$Roadway.Junction.Type %in% c("4-Leg Intersection", "5-Leg or More Intersection", "Alley", 
                                                               "Off-Ramp", "Off-Ramp Diverge Area (Deceleration Lane)", 
                                                               "On-Ramp", "On-Ramp Merge Area (Acceleration Lane)", 
                                                               "Ramp Intersection With Crossroad", "Roundabout/Traffic Circle", 
                                                               "T-Intersection", "Y-Intersection")))
# adjust cols
table(dat_cr$Crash.Severity)
dat_cr$K <- dat_cr$Crash.Severity=="Fatal"
dat_cr$A <- dat_cr$Crash.Severity=="Suspected Serious Injury"
dat_cr$B <- dat_cr$Crash.Severity=="Suspected Minor Injury"
dat_cr$C <- dat_cr$Crash.Severity=="Possible injury"
dat_cr$O <- dat_cr$Crash.Severity=="No injury/PDO"
dat_cr$ONEVEH <- dat_cr$Number.of.Vehicles.Involved==1
dat_cr$ONEVEH <- ifelse(!is.na(dat_cr$ONEVEH), dat_cr$ONEVEH, 
                 ifelse(dat_cr$Manner.of.Collision=="Not Applicable/Single Vehicle", T, F))
# inspect
str(dat_cr)
summary(dat_cr)

########################################
# Function to match segments

match_segs <- function(rt, mb, me, mydata, myout) {
  # filter for route
  temp <- mydata[mydata$ROUTE==rt,]
  temp <- temp[order(temp$MP_BEG, temp$MP_END),]
  temp <- temp[temp$MP_BEG<=me,]
  temp <- temp[temp$MP_END>=mb,]
  # find value
  if (nrow(temp)==0) {
    myval <- NA
  } else if (nrow(temp)==1) {
    myval <- temp[,myout]
  } else if (nrow(temp)>1) {
    # longest distance
    temp$DIST <- temp$MP_END - temp$MP_BEG
    tagg <- aggregate(DIST ~ temp[,myout], data=temp, FUN="sum")
    myval <- tagg[tagg$DIST==max(tagg$DIST),1][1]
    rm(tagg)
  }
  # return
  # return(nrow(temp))
  return(myval)
}

# test 1, 28, 46, 893
# rt <- dat$ROUTE[893]
# mb <- dat$MP_BEG[893]
# me <- dat$MP_END[893]
# mydata <- dat_fc
# myout <- "FUNCLASS"
# mydata <- dat_sp
# myout <- "SPEEDLIM"
# rm(rt, mb, me, mydata, myout)

match_segs_aadt <- function(rt, mb, me, mydata, myout, yr) {
  # filter for route
  temp <- mydata[mydata$ROUTE==rt,]
  temp <- temp[order(temp$MP_BEG, temp$MP_END),]
  temp <- temp[temp$MP_BEG<=me,]
  temp <- temp[temp$MP_END>=mb,]
  # process myout
  if (yr==2023) { yr <- 2022 }
  myout <- paste0(myout, yr)
  # find value
  if (nrow(temp)==0) {
    myval <- NA
  } else if (nrow(temp)==1) {
    myval <- temp[,myout]
  } else if (nrow(temp)>1) {
    # longest distance
    temp$DIST <- temp$MP_END - temp$MP_BEG
    tagg <- aggregate(DIST ~ temp[,myout], data=temp, FUN="sum")
    myval <- tagg[tagg$DIST==max(tagg$DIST),1][1]
    rm(tagg)
  }
  # return
  # return(nrow(temp))
  return(myval)
}

########################################
# Process segments

# Initialize
dat <- rts

# Add urban
temp <- st_intersects(dat, urban, sparse=F)
dat$URBAN <- rowSums(temp)>0
rm(temp)

# Add functional class
dat$FUNCLASS <- sapply(1:nrow(dat), function(x) match_segs(rt=dat$ROUTE[x], mb=dat$MP_BEG[x], me=dat$MP_END[x], mydata=dat_fc, myout="FUNCLASS"))

# Add speed limit
dat$SPEEDLIM <- sapply(1:nrow(dat), function(x) match_segs(rt=dat$ROUTE[x], mb=dat$MP_BEG[x], me=dat$MP_END[x], mydata=dat_sp, myout="SPEEDLIM"))

# Add lanes
# note: this takes several minutes
dat[,names(dat_ln)[4:ncol(dat_ln)]] <- NA
for (i in 4:ncol(dat_ln)) {
  print(names(dat_ln)[i])
  dat[,names(dat_ln)[i]] <- sapply(1:nrow(dat), function(x) match_segs(rt=dat$ROUTE[x], mb=dat$MP_BEG[x], me=dat$MP_END[x], mydata=dat_ln, myout=names(dat_ln)[i]))
}; rm(i)

# Inspect
str(dat)
summary(dat)

# ... delete
saveRDS(dat, "tempdat.rds")
# ... delete

# Make long, add year
dat$YEAR <- NA
datl <- dat
datl$YEAR <- 2017
for (i in 2018:2023) {
  tdat <- dat
  tdat$YEAR <- i
  datl <- rbind(datl, tdat)
  rm(tdat)
}; rm(i)

# Add aadt
# note: this takes several minutes
datl[,c("AADT", "SUTRK", "CUTRK")] <- NA
for (i in c("AADT", "SUTRK", "CUTRK")) {
  print(i)
  datl[,i] <- sapply(1:nrow(datl), function(x) match_segs_aadt(rt=datl$ROUTE[x], mb=datl$MP_BEG[x], me=datl$MP_END[x], mydata=dat_dt, myout=i, yr=datl$YEAR[x]))
}; rm(i)

# Add crashes
tcols <- paste("CRASH", c("ALL", "K", "A", "B", "C", "O", "ONEVEH", "SEATBELT", "PED", "BIKE"), sep="_")
datl[,tcols] <- NA
rm(tcols)
# note: this takes around 30 minutes
for (i in 1:nrow(datl)) {
  if (i %in% seq(0, nrow(datl), 1000)) { print(i) }
  temp <- dat_cr
  temp <- temp[temp$Full.Route.Name==datl$ROUTE[i],]
  temp <- temp[temp$Milepoint<=datl$MP_END[i],]
  temp <- temp[temp$Milepoint>=datl$MP_BEG[i],]
  temp <- temp[temp$Year==datl$YEAR[i],]
  datl$CRASH_ALL[i] <- nrow(temp)
  datl$CRASH_K[i] <- sum(temp$O==T)
  datl$CRASH_A[i] <- sum(temp$O==T)
  datl$CRASH_B[i] <- sum(temp$O==T)
  datl$CRASH_C[i] <- sum(temp$O==T)
  datl$CRASH_O[i] <- sum(temp$O==T)
  datl$CRASH_ONEVEH[i] <- sum(temp$ONEVEH==T)
  datl$CRASH_SEATBELT[i] <- sum(temp$Unrestrained.Involved==T)
  datl$CRASH_PED[i] <- sum(temp$Pedestrian.Involved==T)
  datl$CRASH_BIKE[i] <- sum(temp$Bicycle.Involved==T)
  rm(temp)
}; rm(i)

# Inspect
str(datl)
summary(datl)

# Map
mapview(datl[datl$YEAR==2022, "URBAN"])
mapview(datl[datl$YEAR==2022, "FUNCLASS"])
mapview(datl[datl$YEAR==2022, "SPEEDLIM"])
mapview(datl[datl$YEAR==2022, "LN_THRU"])
mapview(datl[datl$YEAR==2022, "AADT"])
mapview(datl[datl$YEAR==2022, "CRASH_ALL"])
mapview(datl[datl$YEAR==2022, "CRASH_PED"])
mapview(datl[datl$YEAR==2022, "CRASH_BIKE"])

########################################
# Finish

# Rename
crashes_segments <- datl[,names(datl)[names(datl)!="geometry"]]

# Remove geometry
nogeo <- st_drop_geometry(crashes_segments)

# Inspect
str(crashes_segments)
summary(crashes_segments)

# Save
saveRDS(crashes_segments, file=file.path("Data safety", "crashes_segments.rds"))
write.csv(nogeo, file=file.path("Data safety", "crashes_segments.csv"), row.names=F)

# Cleanup
rm(crashes_segments, nogeo, datl)
rm(dat, dat_cr, dat_dt, dat_fc, dat_ln, dat_sp, rts)
rm(aadt, crashes, fclass, lanes, roads, speed, urban)
rm(match_segs, match_segs_aadt)
gc()

########################################
# END #
########################################