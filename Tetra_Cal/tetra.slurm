#!/bin/bash 
#SBATCH --job-name=tetra_cal
#SBATCH --time=40:00:00
##SBATCH --mail-type=none
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=8g
#SBATCH --cpus-per-task=1
#SBATCH --output=/set/your/slurm messages output folder/slurm-%j.out
#SBATCH --array=1-1000

module load R
R CMD BATCH --no-save --no-restore Tetrachoric_Calculation.R messages_output/output_${SLURM_ARRAY_TASK_ID}.Rout
