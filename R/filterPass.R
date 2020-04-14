#' filterPass
#'
#' @description
#' Bcftools filter parser for only keeping PASS variants of a VCF.
#'
#' @inheritParams variantCalling
#' @param vcf Vcf to filter
#' @param out_path Path where to save the output vcf
#' @bcftools Path to bcftools executable
#' @examples
#' \dontrun{
#' filterPass(vcf = 'raw/sample_tumor.vcf',
#'             out_path = 'pass_vcf')
#' }
#'
#' @export
filterPass <- function(bcftools = 'bcftools',
                        vcf,
                        pass_vcf){

  message(paste(Sys.time(),"\n",
                'Starting pass filtering vcf using:\n',
                '>Vcf file:', vcf, '\n'))

  system(paste(bcftools,
               'view -f PASS',
               vcf,
               '>',
               pass_vcf))

  message(paste(Sys.time(),"\n",
                'Finished', vcf, '\n'))
}


