#!R --vanilla

## load libraries
require(ncdf4)
require(chron)
require(raster)
require(sf)
require(abind)

## date of origin of 2949-12-01
ini.date <- chron(julian(x=6, d=1, y=c(1989:2080),origin.=c(month = 12, day = 1, year =1949)),origin.=c(month = 12, day = 1, year =1949))

## Base temperature in Kelvin. Consider 0 or 6°C
temp.base <- 273.15 + 6 # if 6°C is adequate...

for (l in dir(Sys.getenv("TARGET1"),full.names=T,pattern="tasmax")) {

   tst <- nc_open(l)
   if (!exists("tmax")) {
      d <- chron(ncvar_get( tst, "time")/24, origin.=c(month = 12, day = 1, year =1949))
      tmax <- ncvar_get( tst, "tasmax")
      x <- ncvar_get( tst, "lon")
      y <- ncvar_get( tst, "lat")
   } else {
      d <- c(d,chron(ncvar_get( tst, "time")/24, origin.=c(month = 12, day = 1, year =1949)))
      tmax <- abind(tmax,ncvar_get( tst, "tasmax"))
   }
   nc_close( tst)
   tst <- nc_open(gsub("tasmax","tasmin",l))
   if (!exists("tmin")) {
      tmin <- ncvar_get( tst, "tasmin")
   } else {
      tmin <- abind(tmin,ncvar_get( tst, "tasmin"))
   }
   nc_close( tst)
   gc()
}

GDD <- data.frame()
for(i in 1:nrow(y)) {
   for(j in 1:ncol(y)) {
      # Daily Heat Contribution (DHC)
      DHC <- (tmax[i,j,]+tmin[i,j,])/2 - temp.base
      # Year summary of GDD
      GDD <- rbind(GDD,cbind(lat=y[i,j],lon=x[i,j],
         aggregate(data.frame(n=DHC^0,GDD=ifelse(DHC>0,DHC,0)),list(year=cut(d,ini.date,label=1989:2079)),sum)))
      }
   save(file=sprintf("%s/Rdata/%s-%s-%s.rda",Sys.getenv("SCRIPTDIR"),Sys.getenv("PERIOD"),Sys.getenv("MODEL"),Sys.getenv("PRM")),i,j,GDD)
}
gc()

ss <- subset(GDD,n>360)

dts <- with(ss,aggregate(GDD,list(lon,lat),sum))


save(file=sprintf("%s/Rdata/%s-%s-%s.rda",Sys.getenv("SCRIPTDIR"),Sys.getenv("PERIOD"),Sys.getenv("MODEL"),Sys.getenv("PRM")),dts,GDD)

## load(dir(sprintf("%s/Rdata/",Sys.getenv("SCRIPTDIR")),full.names=T)[1])

rslt <- data.frame()

for (arch in dir("tst",pattern="shp",full.names=T)) {
   eco.xy <- st_read(arch)
   xys <- st_coordinates(st_transform(st_centroid(eco.xy),crs = "EPSG:4326"))

   ss <- subset(GDD, n>360 & lon>(min(xys[,1])-1) & lon<(max(xys[,1])+1) & lat>(min(xys[,2])-1) & lat<(max(xys[,2])+1))

   dts <- with(ss,aggregate(data.frame(GDD),list(lon,lat),sum))

   dst <- pointDistance(dts[,1:2],xys,lonlat=T,allpairs=T)

   #Inverse distance weighting
   dst[dst>50000] <- NA
   w <- 1/dst^3
   g <- apply(w,2,function(x) sum(x*dts$GDD,na.rm=T)/sum(x,na.rm=T))

   rslt <- rbind(rslt,data.frame(
      arch=arch,
      area=st_area(eco.xy),
      xy=st_geometry(eco.xy),
      period=Sys.getenv("PERIOD"),
      model=Sys.getenv("MODEL"),
      prm=Sys.getenv("PRM"),
      mean.GDD=g))

      save(file=sprintf("%s/Rdata/%s-%s-%s.rda",Sys.getenv("SCRIPTDIR"),Sys.getenv("PERIOD"),Sys.getenv("MODEL"),Sys.getenv("PRM")),GDD,rslt)
}

arch <- sprintf("%s/Hakea-microcarpa-locs.csv",Sys.getenv("MAPS"))
Hm.xy <- unique(read.table(arch,head=F))
coordinates(Hm.xy) <- 1:2
proj4string(Hm.xy) <-  '+proj=utm +zone=55 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs '
Hm.ll <- spTransform(Hm.xy,"+init=epsg:4326")
xys <- coordinates(Hm.ll)
eco.xy <- st_as_sf(Hm.ll)

ss <- subset(GDD, n>360 & lon>(min(xys[,1])-1) & lon<(max(xys[,1])+1) & lat>(min(xys[,2])-1) & lat<(max(xys[,2])+1))

dts <- with(ss,aggregate(data.frame(GDD),list(lon,lat),sum))

dst <- pointDistance(dts[,1:2],xys,lonlat=T,allpairs=T)

#Inverse distance weighting
dst[dst>50000] <- NA
w <- 1/dst^3
g <- apply(w,2,function(x) sum(x*dts$GDD,na.rm=T)/sum(x,na.rm=T))

rslt <- rbind(rslt,data.frame(
   arch="Hakea-microcarpa-locs.csv",
   area=1000,
   xy=st_geometry(eco.xy),
   period=Sys.getenv("PERIOD"),
   model=Sys.getenv("MODEL"),
   prm=Sys.getenv("PRM"),
   mean.GDD=g))

save(file=sprintf("%s/Rdata/%s-%s-%s.rda",Sys.getenv("SCRIPTDIR"),Sys.getenv("PERIOD"),Sys.getenv("MODEL"),Sys.getenv("PRM")),GDD,rslt)
