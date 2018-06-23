#################################################################
# This script submits all simulation jobs to the SLURM scheduler.
# The use of separate files makes it trivial to set up multiple jobs on different cores.
# This allows timely execution of all of the scripts, yet with easily altered parameters.
#################################################################

mkdir -p logs
R=/Users/lun01/software/R/devel/bin/R

# Submitting the PBMC 68K runs.

sbatch << EOT
#!/bin/bash
#SBATCH -o logs/out-pbmc68k
#SBATCH -e logs/err-pbmc68k
#SBATCH -n 1
#SBATCH --mem 8000

echo 'source("run_pbmc68k.R")' | ${R} --slave --vanilla
EOT
