devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()
out_path <- getwd()

bams <- list.files(bam_path,
                   pattern = "\\-59_BL.bam$",
                   full.names = T)

cores <- 8
memmory <- 24
email = 'clusterigtpmsubirana@gmail.com'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
queue = 'imppcv3'


for(bam in bams){

  sample_name <- gsub("\\.bam", '', basename(bam))
  name = paste0('purple_', sample_name)
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/purple_full.R',
                 bam,
                 cores,
                 out_path)

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email,
                memmory=memmory)

}
