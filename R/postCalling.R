#' postCalling
#'
#' @description
#' Vcf sorting, normalization and reheader of the vcf generated unsing `variantCalling` for posterior annotation. Input file have to
#' present the *_PASS.vcf format and being uncompressed.
#'
#' @inheritParams variantCalling
#' @param pass_vcf Vcf to apply post-calling processing. It should be descompressed and *_PASS.vcf format.
#' @examples
#' \dontrun{
#' postCalling(pass_vcf = 'raw/sample_tumor.bam',
#'             gatk4 = 'bin/gatk-4.1.3.0/gatk',
#'             ref = 'ref/hg38.fa',
#'             bcftools = 'bcftools')
#' }
#'
#' @export
postCalling <- function(pass_vcf,
                        gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
                        ref,
                        bcftools = 'bcftools',
                        out_path){

  message(paste(Sys.time(),"\n",
                'Starting post-calling vcf using:\n',
                '>Vcf file:', pass_vcf, '\n',
                '>Reference genome:', ref, '\n'))

  # correct format vcf
  corr_vcf <- gsub(".vcf", "_corr.vcf", pass_vcf)

  system(paste(gatk4,
               "--java-options '-Xmx8g'",
               'SelectVariants',
               '-V', pass_vcf,
               '-O', corr_vcf,
               '-R', ref))

  # sort vcf
  sorted_vcf <- gsub("_corr.vcf", "_sorted.vcf", corr_vcf)

  system(paste(gatk4,
               'SortVcf',
               '--CREATE_INDEX=true',
               '--SEQUENCE_DICTIONARY', gsub(".fa", ".dict", ref),
               '-I', corr_vcf,
               '-O', sorted_vcf))

  unlink(corr_vcf)
  unlink(paste0(corr_vcf, '.idx'))


  # normalization
  n_vcf <- gsub("_sorted.vcf", "_n.vcf", sorted_vcf)
  system(paste(bcftools, 'norm',
               '-f', ref,
               sorted_vcf,
               '>', n_vcf))

  unlink(sorted_vcf)
  unlink(paste0(sorted_vcf, '.idx'))


  # rehader
  post_name <- gsub("_n.vcf", "_postCalling.vcf", basename(n_vcf))
  reheadered_vcf <- file.path(out_path, post_name)

  bcftoolsReheader(bcftools = bcftools,
                   vcf = n_vcf,
                   reheadered_vcf = reheadered_vcf)

  unlink(n_vcf)

  message(paste(Sys.time(),"\n",
                'Finished', pass_vcf, '\n'))

}

