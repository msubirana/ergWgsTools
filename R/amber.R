amber <- function(amber='/imppc/labs/lplab/share/bin/cobalt/cobalt-1.8.jar',
                   control_mame,
                   control,
                   tumor_name,
                   tumor,
                   output_dir_amber,
                   threads,
                  germline_het_pon='/imppc/labs/lplab/share/marc/refgen/purple/GermlineHetPon.hg38.vcf.gz'){

  system(paste('java -cp -Xmx32G',
               amber,
               'com.hartwig.hmftools.amber.AmberApplication',
               '-reference', control_mame,
               '-reference_bam', control,
               '-tumor', tumor_name,
               '-tumor_bam', tumor,
               '-output_dir', output_dir,
               '-threads', threads,
               '-loci', germline_het_pon))
}
