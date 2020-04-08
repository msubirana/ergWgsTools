devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
bam_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/'
out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/fq'

bams <- list.files(bam_path,
                   pattern = "\\.bam$",
                   full.names = T)
cores <- 28

for(bam in bams){

  sample_name <- gsub("\\.bam", '', basename(bam))
  name = paste0('bamToFq_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/bamTofastqPicard.R',
                 bam,
                 out_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}
