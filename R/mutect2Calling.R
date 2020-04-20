#' mutect2Calling
#'
#' @description
#' Tumor-normal pair somatic variant calling using MuTect2
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' mutect2Calling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                gatk4 = 'bin/gatk-4.1.3.0/gatk',
#'                threads = 2,
#'                af_only_gnomad = 'hg38/af-only-gnomad.hg38.vcf.gz')
#'}
#'
#' @export
mutect2Calling <- function(tumor_file,
                           normal_file,
                           sample_name,
                           ref,
                           out_path,
                           gatk4,
                           threads,
                           af_only_gnomad,
                           bcftools){
  # define output
  out_path <- file.path(out_path, "mutect2")
  dir.create(out_path, showWarnings = F)

  out_mutect2 <- file.path(out_path, paste0(sample_name, "_mutect2"))

  message(paste(Sys.time(),"\n",
                'Starting MuTect2 calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_mutect2, '\n',
                '>Number of threads:', threads, '\n',
                '>Genome aggregation database:', af_only_gnomad))

  # MuTect2 calling
  system(paste(gatk4,
               '--java-options', paste0('-XX:ParallelGCThreads=',threads),
               'Mutect2',
               '-R', ref,
               '-I', tumor_file,
               '-I', normal_file,
               '-O', paste0(out_mutect2, '_raw.vcf'),
               '-germline-resource', af_only_gnomad))

  # PASS variants filtering

  system(paste(gatk4, 'FilterMutectCalls',
               '--java-options', paste0('-XX:ParallelGCThreads=',threads),
               '-V', paste0(out_mutect2, '_raw.vcf'),
               '-R', ref,
               '-O', paste0(out_mutect2, '.vcf')))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))
}
