#!R --vanilla

## load libraries
require(ncdf4)
require(chron)
require(raster)
require(sf)
require(abind)

## time variable in nc files is given as hours since 1949-12-01 00:00:00
## we use this vector of dates in order to break the time series into years:
orig.date <- c(month = 12, day = 1, year =1949)
ini.date <- chron(
   julian(x=6, d=1, y=c(1989:2080), origin.=orig.date),
   origin.=orig.date)

## Base temperature in Kelvin. Consider 0 or 6°C
temp.base <- 273.15 + 6 # if 6°C is adequate...

## Read files from target directory and get time series of time and measurements

for (l in dir(Sys.getenv("TARGET1"),full.names=T,pattern="tasmax")) {

   tst <- nc_open(l)
   if (!exists("tmax")) {
      d <- chron(ncvar_get( tst, "time")/24, origin.=orig.date)
      tmax <- ncvar_get( tst, "tasmax")
      x <- ncvar_get( tst, "lon")
      y <- ncvar_get( tst, "lat")
   } else {
      d <- c(d,chron(ncvar_get( tst, "time")/24, origin.=orig.date))
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

## Calculate Growing Degree Days (GDD) using base temperature
## Formula from: Nicholas Coops, Andrew Loughhead, Philip Ryan & Ron Hutton (2001) Development of daily spatial heat unit mapping from monthly climatic surfaces for the Australian continent, International Journal of Geographical Information Science, 15:4, 345-361, DOI: 10.1080/13658810010011401


GDD <- data.frame()
for(i in 1:nrow(y)) {
   for(j in 1:ncol(y)) {
      # Daily Heat Contribution (DHC)
      DHC <- (tmax[i,j,]+tmin[i,j,])/2 - temp.base
      # Year summary of GDD
      GDD <- rbind(GDD,cbind(lat=y[i,j],lon=x[i,j],
         aggregate(data.frame(n=DHC^0,GDD=ifelse(DHC>0,DHC,0)),
         list(year=cut(d,ini.date, label=1989:2079)),sum,na.rm=T)))
      }
   save(file=sprintf("%s/Rdata/%s-%s-%s.rda",Sys.getenv("SCRIPTDIR"), Sys.getenv("PERIOD"), Sys.getenv("MODEL"), Sys.getenv("PRM")),i,j,GDD)
}
gc()

## Aggregate GDD values for the whole period for each location (exclude incomplete years):

ss <- subset(GDD,n>360)
dts <- with(ss,aggregate(GDD,list(lon,lat),sum))

save(file=sprintf("%s/Rdata/%s-%s-%s.rda",Sys.getenv("SCRIPTDIR"),Sys.getenv("PERIOD"),Sys.getenv("MODEL"),Sys.getenv("PRM")),dts,GDD)
