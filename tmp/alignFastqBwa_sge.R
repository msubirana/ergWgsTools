devools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
fastq_path <- '/imppc/labs/lplab/share/marc/insulinomas/raw/fastq'
out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa'

fastqs <- list.files(fastq_path,
                     pattern = "\\_R1.fq.gz$",
                     full.names = T)
cores <- 28
for(fastq in fastqs){

  sample_name <- gsub("_.*", '', basename(fastq))
  name = paste0('bwa_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/alignFastqBwa.R',
                 fastq,
                 out_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}


