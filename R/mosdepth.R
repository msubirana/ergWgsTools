#' mosdepth
#'
#' @description
#' Fast BAM/CRAM depth calculation for WGS, exome, or targeted sequencing
#'
#' @param inputFile Path of the fastq file to apply depth calculation.
#' @param threads Specify number of threads to use .
#' @param outPath Path where the output of the analysis will be saved.
#'
#' @examples
#' \dontrun{
#' inputFile <- 'raw/sample.bam'
#' ref <- 'ref/hg38.fa'
#' outPath <- 'rst/coverage'
#' threads <- 2
#'
#' mosdepth(inputFile, threads, outPath)
#'}
#'
#' @export
#'

mosdepth <- function(inputFile,
                     threads,
                     outPath){

  fileName = basename(inputFile)
  outFiles = file.path(outPath, fileName)

  message(paste(Sys.time(),"\n",
                'Starting mosdepth coverage using:\n',
                inputFile, 'as a bam\n',
                threads, 'as number of threads\n',
                outPath, 'as output path\n'))

  system(paste("mosdepth",
               outFiles,
               inputFile,
               "-t", threads))

  message(paste(Sys.time(),"\n",
                'Finished mosdepth coverage using:\n',
                inputFile, 'as a bam\n',
                threads, 'as number of threads\n',
                outPath, 'as output path\n'))
}

