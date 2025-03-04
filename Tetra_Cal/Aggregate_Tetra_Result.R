
######
## This R script reads csv files from the folder "results_df", aggregate them together
## and gives a data.frame of column pairwise (each pair of cells) Tetrachoric correlation
## , which is used as dissimilarity matrix used for PCoA (Multi-Dimensional Scaling). 
######

library(dplyr)
library(ggplot2)
library(tidyr)
library(hrbrthemes)
library(viridis)
library(gtools)

setwd("Your/Working/Directory/sc-DNA-Methylation-Cell-Cycle-Analysis/Tetra_Cal")

folder_path <- file.path(getwd(), "results_df")
# csv_files <- list.files(folder_path, pattern = "*.csv", full.names = TRUE)
csv_files <- mixedsort(list.files(folder_path, pattern = "*.csv", full.names = TRUE))
df <- bind_rows(lapply(csv_files, read.csv))[, -1]
write.csv(df, "../tet.csv")
