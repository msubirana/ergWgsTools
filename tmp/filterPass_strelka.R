vcf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw'
vcfs <- list.files(vcf_path,
                   pattern = '*\\.vcf\\.gz$',
                   recursive = T,
                   full.names = T)

out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/pass'

for(vcf in vcfs){

  pass_vcf <- dirname(vcf)
  pass_vcf <- dirname(pass_vcf)
  pass_vcf <- dirname(pass_vcf)
  pass_vcf <- gsub('_out_strelka2', '.vcf', basename(pass_vcf))
  pass_vcf <- file.path(out_path, pass_vcf)

  filterPass(vcf = vcf,
             pass_vcf = pass_vcf)
}

