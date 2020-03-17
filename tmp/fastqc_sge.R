fq_path <- '/imppc/labs/lplab/share/marc/insulinomas/raw/fastq'

fqs <- list.files(fq_path,
           pattern = "*\\.gz",
           full.names = T)

for(fq in fqs){

  sample_name <- gsub("_.*", '', basename(fq))

  cores = 8
  name = paste0('fq_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/fastqc.R',
                 fq,
                 fq_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}
