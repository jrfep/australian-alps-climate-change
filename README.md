# australian-alps-climate-change
Assessment of relative severity of environmental degradation in Australian Alps



# Workflow on Katana @ UNSW

Test in Katana (interactive mode)

```sh
ssh $zID@kdm.restech.unsw.edu.au mkdir -p /srv/scratch/$zID/gisdata/aust-alps

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

```



```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/fire-analysis-aust-alps/load.env
cd $WORKDIR
qsub -J 1-4 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs
qsub -J 5-60 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs
qstat -tu $(whoami)
```
