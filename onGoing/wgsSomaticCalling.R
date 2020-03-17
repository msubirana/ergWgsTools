#' wgsSomaticCalling
#'
#' @description
#' Align, infer the coverage and the quality of the bam or fastq files
#'
#' @param normalBam Normal bam file of the paired normal tumor set to analyse
#' @param tumorBam Tumor bam file of the paired normal tumor set to analyse
#' @param rstPath Path where to save the coverage and quality results. A 'coverage' and 'fastqc' folders will be created.
#' @param vcfPath Path where to save the vcf
#' @param outName Name for the output file for the paired tumor normal analysis
#' @param ref Reference genome
#' @param outPathBam Path where to save the output bam
#' @param threads Number of threads to use in the analysis
#' @param removeOpt Remove the old bam in the case of the bam realignment
#'
#' @examples
#' \dontrun{


#' }
#'
#' @export

vcfPath <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf'


wgsSomaticPreprocessing <- function(normalBam,
                                    tumorBam,
                                    vcfPath,
                                    rstPath,
                                    outName,
                                    threads){




  # purity & cnv
  facetsDir <- file.path(rstPath, 'facets')

  dir.create(facetsDir,
             showWarnings = FALSE)

  facets(normal = normal,
         tumor = tumor,
         outName = outName,
         outPath = facetsDir)

  # manta calling
  # first running manta for use output in a strelka indel infering
  outManta <- file.path(vcfPath, 'manta')

  dir.create(outManta,
               showWarnings = FALSE)

  cores <- as.numeric(threads)/2

  manta(normal = normal,
        tumor = tumor,
        ref = ref,
        outPath = outManta,
        cores = cores,
        outName = outName)

  # strelka calling



  # other callers snv

  # other calles sv or cnv

  # annotation
