devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- getwd()

bams <- list.files(bam_path,
                   pattern = "_BL.bam$",
                   full.names = T)

output_path <- getwd()

for(bam in bams){
  normal_file <- bam
  normal_file_bai <- paste0(normal_file, '.bai')
  tumor_file <- gsub('_BL.bam', '_TI.bam', bam)
  tumor_file_bai <- paste0(tumor_file, '.bai')

  sample_name <- gsub("_.*", '', basename(bam))

  cores = 8
  name = paste0(sample_name, '_mutect2')
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/mutect2Calling.R',
                 tumor_file, normal_file, sample_name, output_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

