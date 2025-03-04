# sc-DNA-Methylation-Cell-Cycle-Analysis

Please see [Progress report](https://www.overleaf.com/9994449956ztrhzxmtynvt#f18ead) (Link is for overleaf) for detailed background and steps for the analysis. Also download gene annotation data from [GENCODE](https://www.gencodegenes.org/human/release_18.html) and put the gtf file in "CpGs_Inside_Gene" folder.

## Setup
First download this "sc-DNA-Methylation-Cell-Cycle-Analysis" folder from github and put it in your working directory.

To run the code, first run the "Annotation.R" script in the "CpGs_Inside_Gene" folder. This will generate a csv file "CpG_Num_Inside_Gene.csv" in the main folder that aligns CpG's position with gene's position to get number of CpGs inside each gene. 

Then run first 216 lines of "Progress_Summarization" markdown file. It will simulate periodic gene-level sc-DNA methylation data (methylation proportion for each gene with 1000 timepoints/cells), expand to CpG-level data using information from "CpG_Num_Inside_Gene.csv". At line 216 it will save the "expanded_matrix.csv" to "Tetra_Cal" folder to compute column pairwise (each pair of cells) Tetrachoric correlation of it (prepare for multi-dimensional scaling).

Next upload the "Tetra_Cal" folder onto computing cluster (Please make sure to creat empty folders "results_df" and "messages_output" inside it). Open this folder on computing cluster and enter ```sbatch tetra.slurm``` to run the "Tetrachoric_Calculation.R" script in multi-nodes. It will save each row of final Tetrachoric correlation matrix into seperate csv files in "results_df" folder on computing cluster. 

For batch file
```bash
#!/bin/bash 
#SBATCH --job-name=Your_job_name
#SBATCH --time=40:00:00
##SBATCH --mail-type=none
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mem=8g
#SBATCH --cpus-per-task=1
#SBATCH --output=/set/your/slurm_messages_output folder/slurm-%j.out
#SBATCH --array=1-1000

module load R
R CMD BATCH --no-save --no-restore Tetrachoric_Calculation.R messages_output/output_${SLURM_ARRAY_TASK_ID}.Rout

```
Please remember to modify the name of "SBATCH --output" to store generated messages and warnings in your home directory on computing cluster. "messages_output" is a folder in "Tetra_Cal" that collects generated messages and warning from "Tetrachoric_Calculation.R" script. You can modify the allocated running time and memory according to your own settings. 

After running "Tetrachoric_Calculation.R" in computing cluster, we need to download the saved "results_df" folder back to local working directory in folder "Tetra_Cal". Now run "Aggregate_Tetra_Result.R" script on your pc. This script will aggregate all files in "results_df" together and gives a data.frame of column pairwise (each pair of cells) Tetrachoric correlation back to main folder, which is used as dissimilarity matrix used for PCoA (Multi-Dimensional Scaling).

After that continue running all other codes left in "Progress_Summarization" markdown file. 

