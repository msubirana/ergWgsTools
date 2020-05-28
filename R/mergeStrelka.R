mergeStrelka <- function(GenomeAnalysisTK='/imppc/labs/lplab/share/bin/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar',
                         refgen,
                         strelka_snvs,
                         strelka_indels,
                         control_name,
                         strelka_merged,
                         strelka_merged_annotated,
                         strelka_merged_annotated_reheader,
                         tumor_name){

  ### Merge strelka snp and indel output
  system(paste('java -jar', GenomeAnalysisTK,
               '-T CombineVariants',
               '-R', refgen,
               '--genotypemergeoption unsorted',
               '-V:snvs', strelka_snvs,
               '-V:indels', strelka_indels,
               '-o', strelka_merged))

  ### Add Allelic Depth field

  system(paste('java -Xmx4G -cp',
               purple, 'com.hartwig.hmftools.purple.tools.AnnotateStrelkaWithAllelicDepth',
               '-in', strelka_merged,
               '-out', strelka_merged_annotated))

  ### Replace NORMAL and TUMOR with actual sample names

  new_header_file <- file.path(dirname(strelka_merged_annotated), 'tmp.header')

  new_header_vcf <- paste0('NORMAL', " ",
                            control_name, '\n',
                            'TUMOR', " ",
                            tumor_name)

  writeLines(new_header_vcf, new_header_file)

  system(paste('bcftools',
               'reheader',
               '-s', new_header_file,
               '-o',strelka_merged_annotated_reheader,
               strelka_merged_annotated))

  unlink(new_header_file)


}
