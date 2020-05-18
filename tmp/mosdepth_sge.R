devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()

bams <- list.files(bam_path,
                   pattern = ".bam$",
                   full.names = T)

output_path <- getwd()

cores = 8
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
queue = 'imppcv3'
email = 'clusterigtpmsubirana@gmail.com'
threads = cores*2

for(bam in bams){

  sample_name <- gsub("_.*", '', basename(bam))

  name = paste0(sample_name, '_mosdepth')
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/mosdepth.R',
                 bam,
                 output_path,
                 threads)


  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

