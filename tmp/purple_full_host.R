devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()
out_path <- getwd()

bams <- list.files(bam_path,
                   pattern = "\\_BL.bam$",
                   full.names = T)
cores <- 24

for(bam in bams){

    system(paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/purple_full.R',
                 bam,
                 cores,
                 out_path))

}
