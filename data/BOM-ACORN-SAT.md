
```sh

mkdir -p $WORKDIR/ACORN-SAT
cd $WORKDIR/ACORN-SAT
tar -xzvf  $GISDATA/climate/BOM/ACORN-SAT/acorn_sat_v2.1.0_daily_tmin.tar.gz
tar -xzvf  $GISDATA/climate/BOM/ACORN-SAT/acorn_sat_v2.1.0_daily_tmax.tar.gz
unzip $GISDATA/climate/BOM/ACORN-SAT/raw-data-and-supporting-information.zip

cd $WORKDIR
```

```r
require(sp)
require(raster)
e1 <- extent(140,156,-44,-27)


wst <-  read.csv("ACORN-SAT/acorn_sat_v2.1.0_stations.csv")
coordinates(wst) <- 4:3
proj4string(wst) <- CRS("+init=epsg:4326")
   wst.xy <- spTransform(crop(wst,e1),"+proj=utm +zone=55 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

BOM.GDD <- data.frame()
for (slc in wst.xy@data$stn_num) {
   dt1 <- read.csv(sprintf("ACORN-SAT/tmin.%06d.daily.csv",slc), skip=2,header=F,col.names=c("date","tmin","stn_num","stn_name"))
   dt2 <- read.csv(sprintf("ACORN-SAT/tmax.%06d.daily.csv",slc), skip=2,header=F,col.names=c("date","tmax","stn_num","stn_name"))
    dts <- merge(dt1[,1:2],dt2[,1:2],by="date")


   temp.base <- 0
   dts$DHC <- (dts$tmax+dts$tmin)/2 - temp.base
   dts$year <- as.numeric(substr(dts$date,0,4))

   # Year summary of GDD

   gdd <- with(dts,aggregate(data.frame(n=!is.na(DHC),GDD=ifelse(DHC>0,DHC,0)),list(year=year),sum,na.rm=T))
   gdd$stn_num <- slc
   gdd$stn_name <- as.character(subset(wst.xy@data,stn_num==slc)$stn_name)

   BOM.GDD <- rbind(BOM.GDD,gdd)
}

plot(GDD~year,BOM.GDD)
plot(GDD~year,data=BOM.GDD,subset=stn_num==96003)

plot(wst.xy)
points(subset(wst.xy,stn_num==96003),col=2)


```

Check if:
* correlation between BOM data and CHELSA / NARCLiM data
* check if trend is consistent (why is it negative in CHELSA/NSW but positive in CHELSA Tas?)
