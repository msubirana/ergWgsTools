# vcfs_strelka <- list.files(vcfs_strelka_path,
#                            pattern = "*.vcf.gz$",
#                            full.names = T)
#
# lapply(vcfs_strelka, function(x) system(paste('gunzip -k', x)))

vcfs_strelka_path <- getwd()
vcfs_strelka <- list.files(vcfs_strelka_path,
                           pattern = "*.vcf$",
                           full.names = T)

bcftools <- 'bcftools'

for(vcf in vcfs_strelka){

  split_vcfs_strelka_path <- unlist(strsplit(vcfs_strelka_path, "/"))
  sample_name <- split_vcfs_strelka_path[grep('^NET', split_vcfs_strelka_path)]
  sample_name <- gsub('_out_strelka2', '', sample_name)

  vcf_out <- file.path(dirname(vcf),
                       paste0(sample_name,
                              gsub('somatic.', '_out_strelka2_',
                                   gsub(".vcf", "_PASS.vcf",
                                        basename(vcf)))))

  system(paste(bcftools, 'view',
               '-f PASS', vcf,
               '>', vcf_out))
}
