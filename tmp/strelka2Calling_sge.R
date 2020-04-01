devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa'

bams <- list.files(bam_path,
                   pattern = "_BL.bam$",
                   full.names = T)

output_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/strelka2'

for(bam in bams){
  normal_file <- bam
  normal_file_bai <- paste0(normal_file, '.bai')
  tumor_file <- gsub('_BL.bam', '_TI.bam', bam)
  tumor_file_bai <- paste0(tumor_file, '.bai')

  # file.copy(normal_file, cluster_folder)
  # file.copy(normal_file_bai, cluster_folder)
  # file.copy(tumor_file, cluster_folder)
  # file.copy(tumor_file_bai, cluster_folder)

  sample_name <- gsub("_.*", '', basename(bam))

  # strelka2Calling
  cores = 8
  name = paste0(sample_name, '_strelka2Calling')
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/strelka2Calling.R',
                 tumor_file, normal_file, sample_name, output_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

