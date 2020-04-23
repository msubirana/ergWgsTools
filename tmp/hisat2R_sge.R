devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
fastq_path <- getwd()
out_path <- '/imppc/labs/lplab/share/insulinoma_hg38/data/RNA/bams/hisat2'

fastq_files <- list.files(fastq_path,
                     pattern = "\\_R1.fq.gz$",
                     full.names = T)
cores <- 28

for(fastq_file in fastq_files){

  sample_name <- gsub("_.*", '', basename(fastq_file))
  name = paste0('bwa_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/hisat2R.R',
                 fastq_file,
                 out_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

