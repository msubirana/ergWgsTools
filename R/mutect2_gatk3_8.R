mutect2_gatk3_8 <- function(GenomeAnalysisTK='/software/debian-8/bio/gatk-3.8/GenomeAnalysisTK.jar',
                            refgen='/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa',
                            tumor,
                            normal,
                            cosmic='/imppc/labs/lplab/share/marc/refgen/hg38/mutect2/CosmicMuts.gatk.vcf.gz',
                            dbsnp='/imppc/labs/lplab/share/marc/refgen/hg38/mutect2/00-common_all.vcf',
                            output,
                            cores){

  threads=cores*2

  system(paste('java -jar',
               '-nt', threads,
               GenomeAnalysisTK,
               '-T MuTect2',
               '-R', refgen,
               '-I:tumor', tumor,
               '-I:normal', normal,
               '--cosmic', cosmic,
               '--dbsnp', dbsnp,
               '--contamination_fraction_to_filter 0.02',
               '-o', output,
               '--output_mode EMIT_VARIANTS_ONLY',
               '--disable_auto_index_creation_and_locking_when_reading_rods'))
}

