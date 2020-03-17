#' strelka2
#'
#' @description
#' Snvs and indels calling of paired tumor-normal wgs using manta
#'
#' @param normal Normal bam file.
#' @param tumor Tumour bam file.
#' @param ref Reference genome.
#' @param outPath Path where the output of the analysis will be saved.
#' @param cores Number of cores to use.
#' @param outName Name for the output file for the paired tumor normal analysis
#' @param indelCandidates For the somatic workflow, the best-practice recommendation is to run the Manta SV and indel caller on the same set of samples first, then supply Manta's candidate indels as input to Strelka
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
#' indelCandidates <- /results/variants/candidateSmallIndels.vcf.gz

#' strelka2(normal = normal,
#'       tumor = tumor,
#'       ref = ref,
#'       outPath = outPath,
#'       cores = cores,
#'       outName = outName)
#'
#' }
#' @export


# TODO germline mutations parse

strelka <- '/soft/bio/strelka-2.9.3'

strelka2 <- function(normal,
                     tumor,
                     ref,
                     outPath,
                     cores,
                     outName,
                     indelCandidates){
  # configuration
  outStrelka <- file.path(outPath, outName)

  # create output directory if not exist
  dir.create(outStrelka, showWarnings = FALSE)

  confStrelka <- file.path(strelka, 'bin/configStrelka.py')

  system(paste(confStrelka,
               "--normalBam", normal,
               "--tumorBam", tumor,
               "--referenceFasta", ref,
               "--runDir", outStrelka,
               '--indelCandidates', indelCandidates))

  # execution of job in the defined cores
  runStrelka <- file.path(outStrelka, 'runWorkflow.py')

  system(paste(runStrelka,
               "-m local",
               "-j", cores))
}


