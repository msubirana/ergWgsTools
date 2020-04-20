bam_path <- getwd()

bams <- list.files(bam_path,
                   pattern = ".bam$",
                   full.names = T)

for(bam in bams){
  sample_name <- gsub("_.*", '', basename(bam))
  cores = 8
  name = paste0('sm_in', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/samtoolsIndex.R',
                 bam)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}
