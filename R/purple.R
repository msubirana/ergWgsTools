purple <- function(purple='/imppc/labs/lplab/share/bin/purple/purple-2.43.jar',
                  control_name,
                  control,
                  tumor_name,
                  tumor,
                  output_dir_purple,
                  output_dir_cobalt,
                  output_dir_amber,
                  threads,
                  somatic_vcf,
                  gc_profile='/imppc/labs/lplab/share/marc/refgen/purple/GC_profile.hg38.1000bp.cnp',
                  circos='/software/debian-8/bio/circos-0.69-9/bin/circos'){

  system(paste('java -jar',
               purple,
               '-reference', control_name,
               '-tumor', tumor_name,
               '-output_dir', output_dir_purple,
               '-amber', output_dir_amber,
               '-cobalt', output_dir_cobalt,
               '-threads', threads,
               '-gc_profile', gc_profile,
               '-ref_genome', refgen,
               '-somatic_vcf', somatic_vcf,
               '-circos', circos))
}

