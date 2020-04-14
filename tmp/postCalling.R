library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/mutect2/postCalling'
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
vcf_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/mutect2/pass'

vcfs <- list.files(vcf_path,
                   full.names = T,
                   pattern = '\\.vcf$')

for(pass_vcf in vcfs){

  postCalling(pass_vcf = pass_vcf,
              ref = ref,
              out_path = out_path)

}





