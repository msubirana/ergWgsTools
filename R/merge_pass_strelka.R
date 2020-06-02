merge_pass_strelka <- function(strelka_path){

  sample_name <- gsub('_out_strelka2', '', basename(strelka_path))
  control_name <- paste0(sample_name, '_BL')
  tumor_name <- paste0(sample_name, '_TI')

  strelka_snvs <- paste0('/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw/',
                         sample_name, '_out_strelka2/results/variants/somatic.snvs.vcf.gz')

  strelka_indels <- paste0('/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw/',
                           sample_name, '_out_strelka2/results/variants/somatic.indels.vcf.gz')

  out_dir <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/merged_postCalling'
  out_path <- out_dir

  dir.create(file.path(out_dir), showWarnings = F)

  strelka_merged <- file.path(out_dir, paste0(sample_name, '_merged.vcf.gz'))
  strelka_merged_annotated <- file.path(out_dir, paste0(sample_name, '_merged_annotated.vcf.gz'))
  strelka_merged_annotated_reheader <- file.path(out_dir, paste0(sample_name, '_merged_annotated_rehader.vcf.gz'))
  strelka_merged_annotated_reheader_pass <- file.path(out_dir, paste0(sample_name, '_merged_annotated_rehader_pass.vcf.gz'))


  mergeStrelka(strelka_snvs=strelka_snvs,
               strelka_indels=strelka_indels,
               control_name=control_name,
               strelka_merged=strelka_merged,
               strelka_merged_annotated=strelka_merged_annotated,
               strelka_merged_annotated_reheader=strelka_merged_annotated_reheader,
               strelka_merged_annotated_reheader_pass=strelka_merged_annotated_reheader_pass,
               tumor_name=tumor_name)

  postCalling(pass_vcf=strelka_merged_annotated_reheader_pass,
              out_path=out_path)

}

