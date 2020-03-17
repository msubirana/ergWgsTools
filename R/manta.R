#' manta
#'
#' @description
#' SVs calling of paired tumor-normal wgs using manta
#'
#' @param normal Normal bam file.
#' @param tumor Tumour bam file.
#' @param ref Reference genome.
#' @param outPath Path where the output of the analysis will be saved.
#' @param cores Number of cores to use.
#' @param outName Name for the output file for the paired tumor normal analysis
#'
#' @examples
#' \dontrun{
#'
#' normal <- 'raw/sample1_BL.bam'
#' tumor <- 'raw/sample1_TI.bam'
#' ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
#' outPath <- 'dir/vcf'
#' cores <- 4
#' outName <- 'sample1'

#' manta(normal = normal,
#'       tumor = tumor,
#'       ref = ref,
#'       outPath = outPath,
#'       cores = cores,
#'       outName = outName)
#'
#' }
#' @export

manta <- '/software/debian-8/bio/manta-1.4.0'

# TODO parse germline mutations

manta <- function(normal,
                  tumor,
                  ref,
                  outPath,
                  cores,
                  outName){
  # configuration
  outManta <- file.path(outPath, outName)

  # create output directory if not exist
  dir.create(outManta, showWarnings = FALSE)

  confManta <- file.path(manta, 'bin/configManta.py')

  system(paste(confManta,
               "--normalBam", normal,
               "--tumorBam", tumor,
               "--referenceFasta", ref,
               "--runDir", outManta))

  # execution of job in the defined cores
  runManta <- file.path(outManta, 'runWorkflow.py')

  system(paste(runManta,
               "-m local",
               "-j", cores))
}


