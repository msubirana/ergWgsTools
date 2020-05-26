devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()
out_path <- getwd()

bams <- list.files(bam_path,
                   pattern = "\\_BL.bam$",
                   full.names = T)

cores <- 24

for(bam in bams){

  sample_name <- gsub("\\.bam", '', basename(bam))
  name = paste0('purple_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/purple_full.R',
                 bam,
                 cores,
                 out_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}
