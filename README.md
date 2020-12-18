# australian-alps-climate-change
Assessment of relative severity of environmental degradation in Australian Alps



# Workflow on Katana @ UNSW

Copy some datasources

```sh
ssh $zID@kdm.restech.unsw.edu.au mkdir -p /srv/scratch/$zID/gisdata/aust-alps

scp -r $WORKDIR/'all states meadows and shrublands' $zID@kdm.restech.unsw.edu.au:/srv/scratch/$zID/gisdata/aust-alps/
```

Clone and update local github repo

```sh
ssh $zID@katana.restech.unsw.edu.au
eval $(ssh-agent)
ssh-add

git clone git@github.com:jrfep/australian-alps-climate-change.git

source $HOME/proyectos/UNSW/australian-alps-climate-change/load.env
cd $SCRIPTDIR
git status
```

To test in Katana (interactive mode) use:

```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/fire-analysis-aust-alps/load.env
cd $WORKDIR
qsub -I -l select=1:ncpus=1:mem=32gb,walltime=4:00:00
#" if we need a graphical session "
##qsub -I -X -l select=1:ncpus=1:mem=32gb,walltime=4:00:00

```

Now run the batch scripts for GDD based on NARCLiM data for all models and scenarios:

```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/australian-alps-climate-change/load.env
cd $WORKDIR
mkdir -p $SCRIPTDIR/Rdata
qsub -J 1-4 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs
qsub -J 5-36 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs
qstat -tu $(whoami)
```
