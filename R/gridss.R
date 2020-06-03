gridss <- function(gridss='/imppc/labs/lplab/share/marc/repos/gridss/gridss.sh',
                   gridss_jar='/imppc/labs/lplab/share/marc/repos/gridss/gridss-2.9.2-gridss-jar-with-dependencies.jar',
                   blacklist='/imppc/labs/lplab/share/marc/refgen/hg38/hg38-blacklist.v2.bed',
                   control_name,
                   control,
                   tumor_name,
                   tumor,
                   output_dir_gridss,
                   threads,
                   refgen='/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa',
                   gc_profile='/imppc/labs/lplab/share/marc/refgen/purple/GC_profile.hg38.1000bp.cnp',
                   jvmheap='24g'){

  sample_name <- gsub('_BL', '', control_name)
  output <- file.path(output_dir_gridss, paste0(sample_name, '.vcf'))
  assembly <- file.path(output_dir_gridss, paste0(sample_name, '_assembly.bam'))

  system(paste(gridss,
               '-r', refgen,
               '-o', output_dir_gridss,
               '-t', threads,
               '-a', assembly,
               '-b', blacklist,
               '--jar', gridss_jar,
               '--jvmheap', jvmheap,
               '--labels', paste0(control_name, ",", tumor_name),
               control, tumor))



}

