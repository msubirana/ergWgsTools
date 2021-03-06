cobalt <- function(cobalt='/imppc/labs/lplab/share/bin/cobalt/cobalt-1.8.jar',
                   control_name,
                   control,
                   tumor_name,
                   tumor,
                   output_dir_cobalt,
                   threads,
                   gc_profile='/imppc/labs/lplab/share/marc/refgen/purple/GC_profile.hg38.1000bp.cnp'){

  system(paste('java -Xmx8G -jar',
               cobalt,
               '-reference', control_name,
               '-reference_bam', control,
               '-tumor', tumor_name,
               '-tumor_bam', tumor,
               '-output_dir', output_dir_cobalt,
               '-threads', threads,
               '-gc_profile', gc_profile))
}
