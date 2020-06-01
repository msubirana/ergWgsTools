devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()

bams <- list.files(bam_path,
                   pattern = "_BL.bam$",
                   full.names = T)

output_path <- file.path(getwd(), 'mutect2')
dir.create(output_path, showWarnings = F)

for(bam in bams){
  normal <- bam
  tumor <- gsub('_BL.bam', '_TI.bam', bam)
  sample_name <- gsub("_.*", '', basename(bam))
  output <- file.path(output_path, paste0(sample_name, '.vcf.gz'))
  cores = 2
  system(paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/mutect2_gatk3_8.R',
                 tumor,
                 normal,
                 output,
                 cores))
}

