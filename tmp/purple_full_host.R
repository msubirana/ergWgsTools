devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
# bam_path <- getwd()
# bams <- list.files(bam_path,
#                    pattern = "\\_BL.bam$",
#                    full.names = T)

bams <- c('/home/labs/lplab/msubirana/media/drive6/insulinomas/processed/hg38/bam/bwa/NET-21_BL.bam')
out_path <- '/home/labs/lplab/msubirana/media/drive6/insulinomas/processed/hg38/purple'
cores <- 2

for(bam in bams){

    system(paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/purple_full.R',
                 bam,
                 cores,
                 out_path))

}
