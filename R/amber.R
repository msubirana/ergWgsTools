amber <- function(amber='/imppc/labs/lplab/share/bin/amber/amber-3.3.jar',
                   control_name,
                   control,
                   tumor_name,
                   tumor,
                   output_dir_amber,
                   threads,
                  germline_het_pon='/imppc/labs/lplab/share/marc/refgen/purple/GermlineHetPon.hg38.vcf.gz'){

  system(paste('java -Xmx32G -jar',
               amber,
               '-reference', control_name,
               '-reference_bam', control,
               '-tumor', tumor_name,
               '-tumor_bam', tumor,
               '-output_dir_amber', output_dir_amber,
               '-threads', threads,
               '-loci', germline_het_pon))
}
