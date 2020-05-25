devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'

bams <- list.files(bam_path,
                   pattern = '\\.bam$',
                   full.names = T)

out_path <- file.path(getwd(), 'realigned')

cores <- 8

for(bam in bams){

  sample_name <- gsub("_.*", '', basename(bam))
  name = paste0('re_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/bamTofastqPicardbwaAlignment.R',
                 bam,
                 out_path,
                 cores)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

