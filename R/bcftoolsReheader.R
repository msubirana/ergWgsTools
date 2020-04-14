#' bcftoolsReheader
#'
#' @description
#' Parser for bcftools reheader
#'
#' @inheritParams variantCalling
#' @param vcf Vcf to reheader.
#' @param vcf_new_names Vector with the new sample names to define in the vcf header.
#' @param reheadered_vcf Path where to save the reheared vcf.
#' @examples
#' \dontrun{
#' bcftoolsReheader(bcftools = 'bcftools', vcf = 'sample.vcf', vcf_new_names = c('NORMAL', 'TUMOR'), reheadered_vcf = 'sample_rh.vcf')
#'}
#' @export

bcftoolsReheader <- function(bcftools,
                             vcf,
                             vcf_new_names = c('NORMAL', 'TUMOR'),
                             reheadered_vcf){

  vcf_old_names <- system(paste(bcftools,
                                'query -l', vcf), intern = T)

  new_header_file <- file.path(dirname(vcf), paste0(sample_name, '.header'))

  new_header_vcf <- paste(c(vcf_old_names[1], " ",
                            vcf_new_names[1], '\n',
                            vcf_old_names[2], " ",
                            vcf_new_names[2]),
                          collapse = "")

  writeLines(new_header_vcf, new_header_file)

  unlink(new_header_file)

  system(paste(bcftools,
               'reheader',
               '-s', new_header_file,
               '-o',reheadered_vcf,
               vcf))

}
