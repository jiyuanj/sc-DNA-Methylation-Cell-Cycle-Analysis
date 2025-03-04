
######
## This R script is used for multi-node computation of column pairwise tetrachoric correlation 
## of "expanded_matrix" (CpG-level methylation data) on computing cluster. This script outputs 
## the number of columns of "expanded_matrix" of csv files to "results_df" folder, where each csv is 
## a 1*1000 data.frame (Tetrachoric correlation of a cell with all other cells). 
######

library(psych)

setwd("~/Tetra_Cal")
expanded_m <- read.csv("expanded.csv")
# write.csv(expanded_m, "results_df/m.csv")

num_cols <- ncol(expanded_m)

tetrachoric_df <- data.frame(matrix(NA, nrow = 1, ncol = num_cols))
colnames(tetrachoric_df) <- colnames(expanded_m)
rownames(tetrachoric_df) <- colnames(expanded_m)[1]

i <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))

for (j in 1:num_cols) {
  if (i == j) {
    tetrachoric_df[j] <- 1  # Self-correlation is always 1
  } else {
    corr_value <- tryCatch({
      tetrachoric(cbind(expanded_m[, i], expanded_m[, j]))$rho[1,2]
    }, error = function(e) NA)  # Handle errors
    tetrachoric_df[j] <- corr_value
  }
}


tetrachoric_df <- as.data.frame(tetrachoric_df)

write.csv(tetrachoric_df, paste0("results_df/tetra_df_row",i,".csv"))