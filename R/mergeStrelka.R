mergeStrelka <- function(GenomeAnalysisTK='/imppc/labs/lplab/share/bin/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar',
                         refgen,
                         strelka_snvs,
                         strelka_indels,
                         control_name,
                         strelka_merged,
                         strelka_merged_annotated,
                         tumor_name){

  ### Merge strelka snp and indel output
  system(paste('java -jar', GenomeAnalysisTK,
               '-T CombineVariants',
               '-R', refgen,
               '--genotypemergeoption unsorted',
               '-V:snvs', strelka_snvs,
               '-V:indels', strelka_indels,
               '-o', strelka_merged))

  ### Replace NORMAL and TUMOR with actual sample names
  system(paste('sed -i',
               '\'s/NORMAL/', control_name, '/g\'', strelka_merged))

  system(paste('sed -i',
               '\'s/TUMOR/', tumor_name, '/g\'', strelka_merged))

  ### Add Allelic Depth field
  system(paste('java -Xmx4G -cp',
               purple, 'com.hartwig.hmftools.purple.tools.AnnotateStrelkaWithAllelicDepth',
               '-in', strelka_merged,
               '-out', strelka_merged_annotated))
}
