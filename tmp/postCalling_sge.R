devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
vcf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/strelka2'
vcf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/strelka2/NET-21_out_strelka2/results/variants'
vcfs <- list.files(vcf_path,
                   pattern = "*\\_PASS\\.vcf",
                   full.names = T
                  #  ,
                  # recursive = T
                  )

for(vcf in vcfs){

  sample_name <- gsub("_.*", '', basename(vcf))
  # postCalling
  cores = 1
  name = paste0('pC_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/postCalling.R',
                 vcf)

  email = 'clusterigtpmsubirana@gmail.com'
  memmory = 10
  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                memmory = memmory,
                script = script,
                email = email)

}

