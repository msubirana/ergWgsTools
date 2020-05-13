devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
vcf_path <- getwd()

vcfs <- list.files(vcf_path,
                   pattern = "*.vcf",
                   full.names = T,
                   recursive = T)

for(vcf in vcfs){

  sample_name <- gsub("_.*", '', basename(vcf))
  # postCalling
  cores = 1
  name = paste0('ann_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  out_vcf <- gsub("_postCalling.vcf", "_annovar_ann.vcf", vcf)
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/annovarAnnotation.R',
                 vcf,
                 out_vcf)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

