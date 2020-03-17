library(ggplot2)
library(tidyverse)
library(ggupset)

vcf_to_vcf <- '/imppc/labs/lplab/share/marc/repos/vcf2maf/vcf2vcf.pl'
GenomeAnalysisTK <- '/imppc/labs/lplab/share/bin/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar'

# correct vcf format
pass_vcfs <- list.files(out_path,
                        pattern = "_PASS.vcf$",
                        full.names = T,
                        recursive = T)

for (pass_vcf in pass_vcfs){
  postCalling(pass_vcf = pass_vcf,
              gatk4 = gatk4,
              ref = ref,
              bcftools = bcftools)
}

rh_vcfs <- list.files(out_path,
                      pattern = "_rhe.vcf$",
                      full.names = T,
                      recursive = T)



################
combined_vcf <- file.path(out_path, paste0(sample_name, "_combined.vcf"))

vcfs_list <- list.files(out_path,
                        pattern = "_rhe.vcf$",
                        full.names = T,
                        recursive = T)


system(paste('java -jar',  GenomeAnalysisTK,
             '-T CombineVariants',
             '-R', ref,
             '--variant', vcfs_list,
             '-o', combined_vcf,
             '-genotypeMergeOptions UNIQUIFY'))


df_vcf <- data.frame()

for(vcf in vcfs_list){
  
  df_tmp <- read.table(vcf)
  tmp_vect <- unlist(strsplit(gsub('_rhe.vcf', '', basename(vcf)), "_"))
  df_tmp$sample <- tmp_vect[1]
  df_tmp$soft <- tmp_vect[2]
  df_tmp$type <- tmp_vect[3]
  df_vcf <- rbind(df_vcf, df_tmp)
  
}

df_vcf$pos <- paste0(df_vcf$V1, "-", df_vcf$V2)
dplyr::summarise()


df_vcf_sub <- df_vcf[c('pos', 'soft')]

df_callers <- aggregate(df_vcf_sub$soft, list(df_vcf_sub$pos), paste, collapse="-")
df_callers$counts <- lapply(df_callers$x, function(x) unlist(strsplit(x, "-")))

library(ggplot2)
library(tidyverse)
library(ggupset)

tidy_callers <- as_tibble(df_callers)
tidy_callers$counts[8]
tidy_callers %>%
  ggplot(aes(x=counts)) +
  geom_bar() +
  scale_x_upset(n_intersections = 20)