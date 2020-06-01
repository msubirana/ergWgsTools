devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()

bams <- list.files(bam_path,
                   pattern = "_BL.bam$",
                   full.names = T)

output_path <- getwd()

for(bam in bams){
  normal <- bam
  tumor <- gsub('_BL.bam', '_TI.bam', bam)
  sample_name <- gsub("_.*", '', basename(bam))
  output <- file.path(output_path, paste0(sample_name, '.vcf.gz'))
  cores = 1
  name = paste0(sample_name, '_mutect2')
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/mutect2_gatk3_8.R',
                 tumor,
                 normal,
                 output)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

