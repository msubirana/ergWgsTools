file_path <- getwd()

files <- list.files(file_path,
                   pattern = '\\.bam$',
                   full.names = T)
out_path <- getwd()

queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
cores = 8
email = 'clusterigtpmsubirana@gmail.com'


for(file in files){

  sample_name <- gsub("_.*", '', basename(bam))

  name = paste0('bam_', sample_name)
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/fastqc.R',
                 file,
                 out_path,
                 cores)

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}
