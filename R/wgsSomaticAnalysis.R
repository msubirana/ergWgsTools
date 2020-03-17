#' wgsSomaticPreprocessing
#'
#' @description
#' Align, infer the coverage and the quality of the bam or fastq files
#'
#' @param inputFile Fastq or bam file to analyse
#' @param ref Reference genome
#' @param outPathBam Path where to save the output bam
#' @param threads Number of threads to use in the analysis
#' @param removeOpt Remove the old bam in the case of the bam realignment
#' @param rstPath Path where to save the coverage and quality results. A 'coverage' and 'fastqc' folders will be created.
#'
#' @examples
#' \dontrun{
#'
#' inputFile <- '/imppc/labs/lplab/share/marc/insulinomas/raw/fastq/NET-25_BL_R1.fq.gz'
#' ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
#' outPathBam <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa'
#' threads <- 4
#' removeOpt <- 'no'
#' rstPath <- '/imppc/labs/lplab/share/marc/insulinomas/rst'

#' wgsSomaticPreprocessing(inputFile = inputFile,
#'                         ref = ref,
#'                         outPathBam = outPathBam,
#'                         threads = threads,
#'                         removeOpt = removeOpt,
#'                         rstPath = rstPath)
#' }
#'
#' @export

wgsSomaticPreprocessing <- function(inputFile,
                                    ref,
                                    outPathBam,
                                    threads,
                                    removeOpt = 'no',
                                    rstPath){

  # define extension and file name
  inputFileSplit <- unlist(regmatches(inputFile, regexpr("[.]", inputFile), invert = TRUE))
  inputFileNonExt <- inputFileSplit[1]
  extension <- inputFileSplit[2]

  # align reads
  if(extension == 'bam'){

    realignBamBwa(inputFile = inputFile ,
                  ref = ref,
                  outPath = outPathBam,
                  threads = threads,
                  removeOpt = removeOpt)

  } else if(extension == 'fq' || extension == 'fasta' || extension == 'fq.gz' || extension == 'fasta.fq'){

    alignFastqBwa(inputFile = inputFile,
                  ref = ref,
                  outPath = outPathBam,
                  threads = threads)

  } else {
    message('Input file not valid, should be a fq or fasta (compressed or not) or a bam file')
  }

  # qc bam
  nameNonExt <- basename(gsub("\\..*$", "", (inputFile)))
  bamFile <- file.path(outPathBam, paste0(nameNonExt, ".bam"))
  fastqcDir <- file.path(rstPath, 'fastqc')
  dir.create(fastqcDir,
             showWarnings = FALSE)

  system(paste('fastqc',
                bamFile,
                '-t', threads,
                '-o', fastqcDir))

  # coverage
  coverageDir <- file.path(rstPath, 'coverage')

  dir.create(coverageDir,
             showWarnings = FALSE)

  mosdepth(inputFile = bamFile,
           threads = threads,
           outPath = coverageDir)

}





