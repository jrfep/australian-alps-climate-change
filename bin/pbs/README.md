
### Workflow on Katana @ UNSW

Please check [Katana User’s documentation](https://unsw-restech.github.io/index.html). In Linux I set up my bash terminal to recognize my zID and set up [SSH Public key authentication](https://www.ssh.com/ssh/public-key-authentication).

Then I use `ssh` and `scp` to copy some datasources using the *katana data mover* (kdm) node:

```sh
ssh $zID@kdm.restech.unsw.edu.au mkdir -p /srv/scratch/$zID/gisdata/aust-alps

scp -r $WORKDIR/'all states meadows and shrublands' $zID@kdm.restech.unsw.edu.au:/srv/scratch/$zID/gisdata/aust-alps/
```

Now I log into the katana node and use `git` to clone and update this repository:

```sh
ssh $zID@katana.restech.unsw.edu.au
## SSH Public key authentication for github
eval $(ssh-agent)
ssh-add

git clone git@github.com:jrfep/australian-alps-climate-change.git

## load bash environment variables
source $HOME/proyectos/UNSW/australian-alps-climate-change/load.env
cd $SCRIPTDIR
git status
```

Explore variables using an interactive `pbs` job:

```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/australian-alps-climate-change/load.env
cd $WORKDIR
qsub -I -l select=1:ncpus=1:mem=32gb,walltime=4:00:00
#" if we need a graphical session "
##qsub -I -X -l select=1:ncpus=1:mem=32gb,walltime=4:00:00
module add python/2.7.15 perl/5.28.0 gdal/2.3.2
gdalinfo /srv/ccrc/data43/z3346206/Deakin/1990-2009/CCCMA3.1/R1/CCRC_NARCliM_DAY_1990-1994_tasmean.nc | less

```

Now run the batch scripts for Growing degree days (GDD) based on NARCLiM data for all models and scenarios:

```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/australian-alps-climate-change/load.env
cd $WORKDIR
##mkdir -p $SCRIPTDIR/Rdata

qsub -l select=1:ncpus=1:mem=32gb,walltime=4:00:00 -J 1-2 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs

qsub -J 5-36 $SCRIPTDIR/bin/pbs/calculate-GDD.pbs
qstat -tu $(whoami)
```

View results in Katana on demand:

```sh
ssh $zID@katana.restech.unsw.edu.au
source $HOME/proyectos/UNSW/australian-alps-climate-change/load.env
cd $WORKDIR

qsub -I -l select=1:ncpus=1:mem=16gb,walltime=1:00:00

source $HOME/proyectos/UNSW/australian-alps-climate-change/load.env
cd $WORKDIR
module add R/4.0.2
module add texlive

R --vanilla
rmarkdown::render('~/proyectos/UNSW/australian-alps-climate-change/doc/GDD-Feldmark-Hakea.Rmd')
rmarkdown::render('~/proyectos/UNSW/australian-alps-climate-change/doc/GDD-Feldmark-Hakea.Rmd',output_format='html_document')
##rmarkdown::render('~/proyectos/UNSW/australian-alps-climate-change/doc/GDD-Feldmark-Hakea.Rmd',output_format='word_document')
rmarkdown::render('~/proyectos/UNSW/australian-alps-climate-change/doc/GDD-Feldmark-Hakea.Rmd',output_format='pdf_document')

## Rscript -e "rmarkdown::render('~/proyectos/UNSW/australian-alps-climate-change/doc/GDD-Feldmark-Hakea.Rmd',output_format='html_document')"


```
