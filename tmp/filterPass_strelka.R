devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

vcf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw'

vcfs <- list.files(vcf_path,
                   pattern = '*\\.vcf\\.gz$',
                   recursive = T,
                   full.names = T)

for(vcf in vcfs){

  pass_path <- file.path(dirname(vcf), 'pass')
  dir.create(pass_path,
             showWarnings = F)

  pass_vcf <- file.path(pass_path, gsub('.gz', '', basename(vcf)))

  filterPass(vcf = vcf,
             pass_vcf = pass_vcf)
}

gatk4 <- '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk'
# for strelka firts is needed to merge snvs and indels if is desired
vcf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw'

strelka_outs <- list.files(vcf_path,
                           pattern = '\\_out\\_strelka2$',
                           full.names = T)

out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/pass'


for(strelka_out in strelka_outs){

  strelka_path <- file.path(strelka_out, 'results', 'variants', 'pass')

  tmp_strsplit <- unlist(strsplit(strelka_path, "/"))
  sample_name <- tmp_strsplit[startsWith(tmp_strsplit, 'NET-')]
  sample_name <- gsub('_out_strelka2', '', sample_name)
  pass_vcf <- file.path(out_path, paste0(sample_name, '.vcf'))

  system(paste(gatk4, 'MergeVcfs',
               '-I', file.path(strelka_path, 'somatic.indels.vcf'),
               '-I', file.path(strelka_path, 'somatic.snvs.vcf'),
               '-O', pass_vcf))

}
