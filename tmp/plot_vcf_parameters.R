# vcf plot parameters
vcf_path_strelka <- '/home/msg/Documents/igtp/insulinomas/strelka/postCalling'
vcf_path_mutect2 <- '/home/msg/Documents/igtp/insulinomas/mutect2/postCalling'

bind_vcfs <- function(vcf_path){

  vcfs <- list.files(vcf_path,
                     pattern = "\\.vcf$",
                     full.names = T)

  vcf_bind <- data.frame()


  for(vcf in vcfs){

    vcf_table <- read.table(vcf)

    colnames(vcf_table) <- c('CHROM', 'POS', 'ID', 'REF',
                             'ALT', 'QUAL', 'FILTER', 'INFO',
                             'FORMAT', 'NORMAL', 'TUMOR')

    vcf_table$sample <- unlist(strsplit(basename(vcf), "_"))[1]

    vcf_bind <- rbind(vcf_bind, vcf_table)
  }

  vcf_bind$type <- 'SNV'

  vcf_bind$type[(nchar(as.character(vcf_bind$REF)) > 1) | (nchar(as.character(vcf_bind$ALT)) > 1)] <- 'INDEL'


  return(vcf_bind)
}

strelka_vcfs <- bind_vcfs(vcf_path = vcf_path_strelka)
mutect2_vcfs <- bind_vcfs(vcf_path = vcf_path_mutect2)
strelka_vcfs$caller <- 'Strelka2'
mutect2_vcfs$caller <- 'Mutect2'

vcf_matrix <- rbind(strelka_vcfs, mutect2_vcfs)

library(ggplot2)
library(cowplot)

ggplot(mutect2_vcfs, aes(x = sample)) +
  geom_bar(aes(fill=type)) +
  theme(axis.text.x=element_text(angle=90, hjust=1)) +
  ylab('Number of variants') + facet_grid(rows = vars(caller))
