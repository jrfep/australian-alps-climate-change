# australian-alps-climate-change
Assessment of relative severity of environmental degradation in Australian Alps



# Katana
Test in Katana (interactive mode)

```sh
$zID@kdm.restech.unsw.edu.au mkdir -p /srv/scratch/$zID/gisdata/aust-alps

scp -r $WORKDIR/'all states meadows and shrublands' $zID@kdm.restech.unsw.edu.au:/srv/scratch/$zID/gisdata/aust-alps/
```

```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/fire-analysis-aust-alps/load.env
cd $SCRIPTDIR
git status
```

Start interactive session and test...
```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/fire-analysis-aust-alps/load.env
cd $WORKDIR
qsub -I -l select=1:ncpus=1:mem=32gb,walltime=4:00:00
#" if we need a graphical session "
##qsub -I -X -l select=1:ncpus=1:mem=32gb,walltime=4:00:00

r0 <- rasterFromXYZ(dts[,c(2,1,3)], res=c(NA,NA), crs=CRS("+init=epsg:4326"), digits=3)
 coordinates(dts) <- 2:1
 proj4string(dts) <-  CRS("+init=epsg:4326")
gridded(dts) <- TRUE
r1 <- raster(dts)
r1

```

```sh
cd $WORKDIR
qsub -J 1-4 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs
qsub -J 5-60 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs
qstat -tu $(whoami)

## this has an error and produced huge output files
##qsub -J 9-100 $SCRIPTDIR/bin/pbs/query-locations.pbs
##ls -Rlh /srv/scratch/$(whoami)/aust-alps/
##find /srv/scratch/$(whoami)/aust-alps/ -name '*csv'
```
