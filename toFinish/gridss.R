gridss <- function(gridss='/imppc/labs/lplab/share/marc/repos/gridss/gridss.sh',
                   gridss_jar='/imppc/labs/lplab/share/marc/repos/gridss/gridss-2.9.2-gridss-jar-with-dependencies.jar',
                   blacklist='/imppc/labs/lplab/share/marc/refgen/hg38/hg38-blacklist.v2.bed'
                   control_name,
                   control,
                   tumor_name,
                   tumor,
                   output_dir_cobalt,
                   threads,
                   gc_profile='/imppc/labs/lplab/share/marc/refgen/purple/GC_profile.hg38.1000bp.cnp'){

  system(paste(gridss,
               '-r', refgen,
               '-o', ,
               '-t', threads,
               '-a', assembly,
               '-b', blacklist,
               '--jar', gridss_jar,
               '--jvmheap 25g',
               bam



               }
