#################################################################
# This script submits all simulation jobs to the SLURM scheduler.
# The use of separate files makes it trivial to set up multiple jobs on different cores.
# This allows timely execution of all of the scripts, yet with easily altered parameters.
#################################################################

mkdir -p logs
R=/Users/lun01/software/R/devel/bin/R

# Submitting the hypercube simulations.

sbatch << EOT
#!/bin/bash
#SBATCH -o logs/out-hyper
#SBATCH -e logs/err-hyper
#SBATCH -n 1
#SBATCH --mem 2000

echo 'source("sim_hypercube.R")' | ${R} --slave --vanilla
EOT

# Submitting the gaussian cluster simulations with varying parameters.

for nclust in 10 100
do
    for sd in 2 5
    do
sbatch << EOT
#!/bin/bash
#SBATCH -o logs/out-gauss-${nclust}-${sd}
#SBATCH -e logs/err-gauss-${nclust}-${sd}
#SBATCH -n 1
#SBATCH --mem 2000

echo 'NCLUST <- ${nclust}; SD <- ${sd}; source("sim_gaussclust.R")' | ${R} --slave --vanilla
EOT
    done
done

# Submitting the helical simulations with varying parameters.

for height in 1 5
do
    for cycles in 1 5
    do
sbatch << EOT
#!/bin/bash
#SBATCH -o logs/out-helix-${height}-${cycles}
#SBATCH -e logs/err-helix-${height}-${cycles}
#SBATCH -n 1
#SBATCH --mem 2000

echo 'HEIGHT <- ${height}; CYCLES <- ${cycles}; source("sim_helical.R")' | ${R} --slave --vanilla
EOT
    done
done
