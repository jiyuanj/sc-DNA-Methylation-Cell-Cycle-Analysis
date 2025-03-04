
######
## This R script reads "gencode.v18.annotation.gtf" file and "csv.txt" file from the folder "CpGs Inside Gene", aggregate them together
## and gives a data.frame of number of CpGs inside each gene. 
######

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("rtracklayer")

library(rtracklayer)
library(dplyr)

setwd("Your/Working/Directory/sc-DNA-Methylation-Cell-Cycle-Analysis/CpGs_Inside_Gene")


### Read Necessary Files and Processing

## Read Gene Annotation Data

gtf <- rtracklayer::import('gencode.v18.annotation.gtf')
gtf_df <- as.data.frame(gtf)
gtf_df<- gtf_df[gtf_df$type=="gene",]
colnames(gtf_df)[colnames(gtf_df) %in% c("seqnames", "start", "end")] <- c("chrom", "gene_start", "gene_end")

## Read CpG Position Data

CpG_df <- read.csv("csv.txt", header = TRUE)
colnames(CpG_df)[colnames(CpG_df) %in% c("chromStart", "chromEnd")] <- c("cpg_start", "cpg_end")

## Join them together

# Inner join by chromosome
merged_data <- merge(
  gtf_df %>% dplyr :: select(gene_name, chrom, gene_start, gene_end),
  CpG_df %>% dplyr :: select(chrom, cpg_start, cpg_end, cpgNum),
  by = "chrom"
)

# Filter CpGs that fall within the gene region
cpg_in_genes <- merged_data %>%
  filter(cpg_start >= gene_start & cpg_end <= gene_end)

# Count the number of CpGs per gene
cpg_counts_per_gene <- cpg_in_genes %>%
  group_by(gene_name, chrom, gene_start, gene_end) %>%
  summarise(total_cpg_num = sum(cpgNum), .groups = "drop")

# Convert to data frame
cpg_counts_per_gene <- as.data.frame(cpg_counts_per_gene)

write.csv(cpg_counts_per_gene,"../CpG_Num_Inside_Gene.csv", row.names = TRUE)
