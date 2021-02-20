
```sh

mkdir -p $WORKDIR/ACORN-SAT
cd $WORKDIR/ACORN-SAT
tar -xzvf  $GISDATA/climate/BOM/ACORN-SAT/acorn_sat_v2.1.0_daily_tmin.tar.gz
tar -xzvf  $GISDATA/climate/BOM/ACORN-SAT/acorn_sat_v2.1.0_daily_tmax.tar.gz
unzip $GISDATA/climate/BOM/ACORN-SAT/raw-data-and-supporting-information.zip

cd $WORKDIR
```

```r
#!R --vanilla
require(sp)
require(raster)
require(chron)
require(dplyr)


e1 <- extent(140,156,-44,-27)


wst <-  read.csv("ACORN-SAT/acorn_sat_v2.1.0_stations.csv")
coordinates(wst) <- 4:3
proj4string(wst) <- CRS("+init=epsg:4326")
   wst.xy <- spTransform(crop(wst,e1),"+proj=utm +zone=55 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

BOM.GDD <- data.frame()
for (slc in wst.xy@data$stn_num) {
     dt1 <- read.csv(sprintf("ACORN-SAT/tmin.%06d.daily.csv",slc), skip=2,header=F,col.names=c("date","tmin","stn_num","stn_name"), as.is=T)
     dt2 <- read.csv(sprintf("ACORN-SAT/tmax.%06d.daily.csv",slc), skip=2,header=F,col.names=c("date","tmax","stn_num","stn_name"), as.is=T)
      dts <- merge(dt1[,1:2],dt2[,1:2],by="date")

    ## use approx to fill the NA with interpolation from neighboring values
  dts %>% mutate(f1=chron(dts$date,format="y-m-d")) %>% mutate(tmin.cor=approx(f1,tmin,f1)$y,tmax.cor=approx(f1,tmax,f1)$y) -> dts

  ## this might introduce some errors (tmax above tmin), but this is not critical
  # subset(dts,tmax.cor<tmin.cor)

  ## Accumulate heat above base temperature
  dts %>%  mutate(DHC0=(tmax.cor+tmin.cor)/2 - 0, DHC5=(tmax.cor+tmin.cor)/2 - 5,year=years(f1)) -> dts

   # Year summary of GDD
   gdd <- dts %>% group_by(year) %>%
    summarise(n=n(), n.measured=sum(!is.na(tmin) & !is.na(tmax)),
      GDD0=sum(ifelse(DHC0>0,DHC0,0)), GDD5=sum(ifelse(DHC5>0,DHC5,0)),
      GDD0.raw=sum(ifelse(!is.na(tmin) & !is.na(tmax) &  DHC0>0,DHC0,0)),
      GDD5.raw=sum(ifelse(!is.na(tmin) & !is.na(tmax) &  DHC5>0,DHC5,0))) %>%
      mutate(stn_num=slc,stn_name= as.character(subset(wst.xy@data,stn_num==slc)$stn_name))
   BOM.GDD <- rbind(BOM.GDD,gdd)
}

plot(GDD~year,BOM.GDD)
plot(GDD~year,data=BOM.GDD,subset=stn_num==96003)

plot(wst.xy)
points(subset(wst.xy,stn_num==96003),col=2)


save(file="BOM-ACORN-data.rda",BOM.GDD,wst.xy)
```

Copy this to a location in Katana:

```sh
scp BOM-ACORN-data.rda $zID@kdm.restech.unsw.edu.au:/srv/scratch/$zID/gisdata/aust-alps/

```
Check if:
* correlation between BOM data and CHELSA / NARCLiM data
* check if trend is consistent (why is it negative in CHELSA/NSW but positive in CHELSA Tas?)
