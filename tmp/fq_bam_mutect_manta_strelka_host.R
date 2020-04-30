devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- '/media/msubirana/plab1/resorted'
out_path <- '.'

bams <- list.files(bam_path,
                   pattern = "\\_BL.bam$",
                   full.names = TRUE)
cores <- 4

for(bam in bams){

  system(paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/fq_bam_mutect_manta_strelka.R',
                 bam,
                 out_path))

}
