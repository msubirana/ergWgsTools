library(maftools)
#all your annovar outputs per sample
vcf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/strelka2'

vcfs <- list.files(vcf_path,
                   pattern = "*\\_postCalling\\.vcf$",
                   full.names = T,
                   recursive = T)
bcftools <- 'bcftools'
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
gatk3 <- '/soft/bio/gatk-3.8/GenomeAnalysisTK.jar'
vcf2maf <- '/imppc/labs/lplab/share/marc/repos/vcf2maf/vcf2maf.pl'
maf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/strelka2'
out_maftools <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/maf/mafTools'
maf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/strelka2'

sample_names <- unlist(lapply(vcfs, function(vcf) paste0(unlist(strsplit(basename(vcf), "_"))[1], "_")))
sample_names <- unique(sample_names)

for(sample_name in sample_names){
  sub_list <- vcfs[grepl(sample_name, vcfs)]
  snv_vcf <- sub_list[grepl("snvs", sub_list)]
  indel_vcf <- sub_list[grepl("indels", sub_list)]
  vcf_merged <- file.path(maf_path, paste0(gsub("_", "", sample_name), ".vcf"))
  maf <- file.path(maf_path, paste0(gsub("_", "", sample_name), ".maf"))
  # merge snvs, indels

  system(paste('java -jar',
               gatk3,
               '-T CombineVariants',
               '-R', ref,
               '-genotypeMergeOptions PRIORITIZE',
               '--rod_priority_list snv,indel',
               '--variant:snv', snv_vcf,
               '--variant:indel', indel_vcf,
               '-o', vcf_merged))

  normal_name = paste0(sample_name, '_BL')
  tumor_name = paste0(sample_name, '_TI')

  reheadered_vcf <- paste0(gsub("*\\.vcf$", "", vcf_merged), '_rh.vcf')

  bcftoolsReheader(bcftools,
                   vcf_merged,
                   vcf_new_names = c(normal_name, tumor_name),
                   reheadered_vcf)

}

vcfs = list.files(maf_path,
                       full.names = TRUE,
                       pattern = "*\\.vcf$")

for(vcf in vcfs){

  sample_name <- gsub("*\\.vcf$", "", basename(vcf))



  system(paste('bgzip -c',
               reheadered_vcf,
               '>', paste0(reheadered_vcf, '.gz')))

  system(paste('tabix -p vcf',
               paste0(reheadered_vcf, '.gz')))
}
#
#
# bcftools merge -O z -o merged.vcf.gz *.gz
# # for(sample_name in sample_names){
# #   sub_list <- vcfs[grepl(sample_name, vcfs)]
# #   snv_vcf <- sub_list[grepl("snvs", sub_list)]
# #   indel_vcf <- sub_list[grepl("indels", sub_list)]
# #   vcf_merged <- file.path(maf_path, paste0(gsub("_", "", sample_name), ".vcf"))
# #   maf <- file.path(maf_path, paste0(gsub("_", "", sample_name), ".maf"))
# #   # merge snvs, indels
# #
# #   system(paste('java -jar',
# #                gatk3,
# #                '-T CombineVariants',
# #                '-R', ref,
# #                '-genotypeMergeOptions PRIORITIZE',
# #                '--rod_priority_list snv,indel',
# #                '--variant:snv', snv_vcf,
# #                '--variant:indel', indel_vcf,
# #                '-o', vcf_merged))
# #
# #   tumor_id <- "TUMOR"
# #   normal_id <- "NORMAL"
# #   # vcf to maf and vep annotation
# #
# #   system(paste('perl',
# #                vcf2maf,
# #                '--input-vcf', vcf_merged,
# #                '--output-maf', maf,
# #                '--tumor-id', tumor_id,
# #                '--normal-id', normal_id,
# #                '--vep-path /imppc/labs/lplab/share/bin/ensembl-vep',
# #                '--ref-fasta', ref,
# #                '--filter-vcf 0',
# #                '--ncbi-build GRCh38',
# #                '--vep-data /imppc/labs/lplab/share/bin/ensembl-vep/cache'))
# #
# #
# # }
#

library(maftools)
#gunzip merged vcf gz
merged_vcf <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/strelka2/merged.vcf'
maf <- paste0(gsub("\\.vcf$", "", merged_vcf), '.maf')
# system(paste('perl',
#                             vcf2maf,
#                             '--input-vcf', merged_vcf,
#                            '--output-maf', maf,
#                              '--vep-path /imppc/labs/lplab/share/bin/ensembl-vep',
#                              '--ref-fasta', ref,
#                              '--filter-vcf 0',
#                              '--ncbi-build GRCh38',
#                              '--vep-data /imppc/labs/lplab/share/bin/ensembl-vep/cache'))

vep_maf <- maftools::read.maf(maf)

#Shows sample summry.
getSampleSummary(vep_maf)
#Writes maf summary to an output file with basename mergedMafs.
maftools::write.mafSummary(maf = vep_maf, basename = file.path(out_maftools, 'maf_summary.txt'))

#lot the summary of the maf file, which displays number of variants in each sample as a stacked barplot and variant types

pdf_file <- file.path(out_maftools, 'plotmafSummary.pdf')
pdf(file = pdf_file)
plotmafSummary(maf = vep_maf, rmOutlier = TRUE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE)
dev.off()

#oncoplot for top ten mutated genes.
pdf_file <- file.path(out_maftools, 'oncoplot.pdf')
pdf(file = pdf_file)
oncoplot(maf = vep_maf,
         top = 25,
         showTumorSampleBarcodes = TRUE)
dev.off()
# transition and transversions summary
merged_mafs.titv = titv(maf = merged_mafs, plot = FALSE, useSyn = TRUE)
#plot titv summary
pdf_file <- file.path(out_maftools, 'plotTiTv.pdf')
pdf(file = pdf_file)
plotTiTv(res = merged_mafs.titv)
dev.off()

# rainfall plots
pdf_file <- file.path(out_maftools, 'rainfallPlot.pdf')
pdf(file = pdf_file)
rainfallPlot(maf = merged_mafs, detectChangePoints = TRUE, pointSize = 0.6)
dev.off()


# compare mutation load against TCGA cohorts
pdf_file <- file.path(out_maftools, 'mutload.pdf')
pdf(file = pdf_file)
merged_mafs.mutload = tcgaCompare(maf = merged_mafs, cohortName = 'Example-mergedMafs')
dev.off()
