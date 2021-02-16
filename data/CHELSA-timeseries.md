# CHELSA climate Version 1.2

[CHELSA climate](http://chelsa-climate.org/) (version 1.2) includes several data products. Technical specification at https://chelsa-climate.org/wp-admin/download-page/CHELSA_tech_specification.pdf


## Data download and preparation

The recommended method is to use the [download server](https://envicloud.wsl.ch/#/?prefix=chelsa%2Fchelsa_V1).

Once in the server, is easy to select the files needed, and download a list of files paths for download with several tools. Here I use `wget` to download data for Growing Degree Days above 0°C:

```sh
mkdir -p $GISDATA/clima/CHELSA/GDD0
mv ~/Downloads/envidatS3paths.txt  $GISDATA/clima/CHELSA/GDD0
cd $GISDATA/clima/CHELSA/GDD0
wget --continue -i envidatS3paths.txt

mkdir -p $GISDATA/clima/CHELSA/GTS0
mv ~/Downloads/envidatS3paths.txt  $GISDATA/clima/CHELSA/GTS0
cd $GISDATA/clima/CHELSA/GTS0
wget --continue -i envidatS3paths.txt


```

```sh
cd $WORKDIR


for j in $(seq 1979 2013)
do
   ## australian alps (mainland)
   gdalwarp -s_srs EPSG:4326 $GISDATA/clima/CHELSA/GTS0/CHELSA_gts0_${j}_V1.2.1.tif -t_srs '+proj=utm +zone=55 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ' -te 390989.1 5751747.1 680788.2  6188808.0 -of 'GTiff' CHELSA_gts0_${j}_V1.2.1-AustAlps.tif

   ## tasmania
   gdalwarp -s_srs EPSG:4326 $GISDATA/clima/CHELSA/GTS0/CHELSA_gts0_${j}_V1.2.1.tif -t_srs '+proj=utm +zone=55 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ' -te 389422 5155864 619304 5482542 -of 'GTiff' CHELSA_gts0_${j}_V1.2.1-Tasmania.tif
done
```

```sh
ssh $zID@kdm.restech.unsw.edu.au mkdir -p /srv/scratch/${zID}/gisdata/aust-alps/CHELSA/GTS

scp $WORKDIR/CHELSA_gts0*AustAlps.tif $zID@kdm.restech.unsw.edu.au:/srv/scratch/${zID}/gisdata/aust-alps/CHELSA/GTS/

scp $WORKDIR/CHELSA_gts0*Tasmania.tif $zID@kdm.restech.unsw.edu.au:/srv/scratch/${zID}/gisdata/aust-alps/CHELSA/GTS/

```



#### References

* Karger, D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W., Zimmermann, N.E., Linder, P., Kessler, M. (2017). Climatologies at high resolution for the Earth land surface areas. Scientific Data. 4 170122. https://doi.org/10.1038/sdata.2017.122
* Karger D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza, R.W., Zimmermann, N.E,, Linder, H.P., Kessler, M.. Data from: Climatologies at high resolution for the earth’s land surface areas. Dryad Digital Repository.http://dx.doi.org/doi:10.5061/dryad.kd1d4
