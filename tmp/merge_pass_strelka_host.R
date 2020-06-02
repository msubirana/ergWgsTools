devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
raw_strelka <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw'
strelka_paths <- list.files(raw_strelka,
                            full.names = T,
                            pattern = '_out_strelka2$')

for(strelka_path in strelka_paths){
  merge_pass_strelka(strelka_path)
}
