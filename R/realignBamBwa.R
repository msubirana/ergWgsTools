#' realignBamBwa
#'
#' This function realigns bam files using a defined reference genome and bwa being possible to
#' use paired or single end data (type will be detected automatically)
#'
#' @param inputFile Path of the fastq file to align.
#' @param threads Number of threads to use in the analysis.
#' @param ref Path where the reference genome is save.
#' @param outPath Path where the output of the analysis will be saved.
#' @param removeOpt Remove old bam option (yes or no)
#'
#' @examples
#' \dontrun{
#' inputFile <- 'raw/sample.bam'
#' ref <- 'ref/hg38.fa'
#' outPath <- 'rst'
#' threads <- 2
#' removeOpt <- 'yes'
#'
#' realignBamBwa(inputFile, ref, outPath, threads, removeOpt)
#'}
#'
#' @export

realignBamBwa <- function(inputFile,
                          ref,
                          outPath,
                          threads,
                          removeOpt){


  gatk <- '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk'

  nameNonExt <- basename(tools::file_path_sans_ext(inputFile))

  # define type of bam

  samType <- system(paste('sambamba view',
                          '-t', threads,
                          '-c -f 1', inputFile), intern = T)

  samType <- as.numeric(samType)


  if (samType > 0){
    type = 'paired'

  } else if (samType == 0){
    type = 'single'}

  # if index does not exists, create it

  index <- paste0(inputFile, '.bai')

  if(!file.exists(index)){
    system(paste("sambamba index",
                 "-t", threads,
                 inputFile))
  }

  # realign bam depending on the type

  message(paste(Sys.time(),"\n",
                'Starting realigning using:\n',
                type, 'as bam type\n',
                inputFile, 'as a bam\n',
                ref, 'as reference genome\n',
                outPath, 'as output path\n'))

  if (type == 'single'){

    outFq <- file.path(outPath, paste0(nameNonExt, ".fq"))
    outBam <- file.path(outPath, paste0(nameNonExt, ".bam"))

    system(paste(gatk,
                 '--java-options', paste0('-XX:ParallelGCThreads=',threads),
                 'SamToFastq',
                 "-I", inputFile,
                 "-F", outFq))

    system(paste('bwa mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", "\\tPU:1\\tSM:", "\\tPL:ILLUMINA\""),
                 ref,
                 outFq, "|",
                 'samblaster -M |',
                 'sambamba view',
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 'sambamba sort',
                 '-t', threads,
                 '--tmpdir', outPath,
                 '-o', outBam,
                 '/dev/stdin ;',
                 "sambamba index",
                 "-t", threads,
                 outBam))

    system(paste('rm', outFq))


  } else if (type == 'paired'){

    outFq1 <- file.path(outPath, paste0(nameNonExt, "_R1.fq"))
    outFq2 <- file.path(outPath, paste0(nameNonExt, "_R2.fq"))
    outBam <- file.path(outPath, paste0(nameNonExt, ".bam"))


    system(paste(gatk,
                 '--java-options', paste0('-XX:ParallelGCThreads=',threads),
                 'SamToFastq',
                 "-I", inputFile,
                 "-F", outFq1,
                 "-F2", outFq2))

    system(paste('bwa mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", "\\tPU:1\\tSM:", "\\tPL:ILLUMINA\""),
                 ref,
                 outFq1, outFq2, "|",
                 'samblaster -M |',
                 'sambamba view',
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 'sambamba sort',
                 '-t', threads,
                 '--tmpdir', outPath,
                 '-o', outBam,
                 '/dev/stdin ;',
                 "sambamba index",
                 "-t", threads,
                 outBam))

    system(paste('rm', outFq1, outFq2))

    if (removeOpt == 'yes'){
      system(paste('rm', inputFile))
    }
  }

  message(paste(Sys.time(),"\n",
                'Finished realigning using:\n',
                type, 'as bam type\n',
                inputFile, 'as a bam\n',
                ref, 'as reference genome\n',
                outPath, 'as output path\n'))
}
