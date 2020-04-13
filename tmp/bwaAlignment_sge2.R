devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
fastq_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/fq/realigned'
out_path <- fastq_path

fastqs <- list.files(fastq_path,
                     pattern = "\\_R1.fq$",
                     full.names = T)
cores <- 28

for(fastq in fastqs){

  sample_name <- gsub("_.*", '', basename(fastq))
  name = paste0('bwa_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/bwaAlignment2.R',
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

