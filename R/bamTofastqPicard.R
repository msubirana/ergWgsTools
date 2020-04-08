#' bamTofastqPicard
#'
#' This function converts BAM files to FASTQ files using GATK4 SamToFastq. Type of BAM file (paried or single) is detected
#' automatically.
#'
#' @inheritParams somaticWgsAnalysis
#'
#' @examples
#' \dontrun{
#' bamTofastqPicard(bam = 'raw/sample.bam',
#'              ref = 'ref/hg38.fa',
#'              out_path = 'rst',
#'              threads = '2')
#' }
#' @export
bamTofastqPicard <- function(bam,
                             ref,
                             out_path,
                             threads,
                             gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
                             sambamba = 'sambamba',
                             samtools = 'samtools'){

  # if index does not exists, create it
  index <- paste0(bam, '.bai')

  if(!file.exists(index)){
    samtoolsIndex(bam = bam,
                  threads = threads,
                  samtools = samtools)
  }

  name_non_ext <- basename(tools::file_path_sans_ext(bam))

  # define type of bam
  sam_type <- system(paste(sambamba, 'view',
                           '-t', threads,
                           '-c -f 1', bam), intern = T)
  sam_type <- as.numeric(sam_type)


  if (sam_type > 0){
    type = 'paired'
  } else if (sam_type == 0){
    type = 'single'}

  # realign bam depending on the type
  message(paste(Sys.time(),"\n",
                'Starting BAM to FASTQ conversion using:\n',
                '>Input file:', bam, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_path, '\n',
                '>Number of threads:', threads))

  if (type == 'single'){

    out_fq <- file.path(out_path, paste0(name_non_ext, ".fq"))

    system(paste(gatk4,
                 '--java-options', paste0('-XX:ParallelGCThreads=', threads),
                 'SamToFastq',
                 "-I", bam,
                 "-F", out_fq))

    message(paste(Sys.time(),"\n",
                  'Finished', basename(bam)))

    return(out_fq)

  } else if (type == 'paired'){

    out_fq1 <- file.path(out_path, paste0(name_non_ext, "_R1.fq"))
    out_fq2 <- file.path(out_path, paste0(name_non_ext, "_R2.fq"))

    system(paste(gatk4,
                 '--java-options', paste0('-XX:ParallelGCThreads=',threads),
                 'SamToFastq',
                 "-I", bam,
                 "-F", out_fq1,
                 "-F2", out_fq2))

  }

  message(paste(Sys.time(),"\n",
                'Finished BAM to FASTQ conversion', bam, '\n'))

  return(out_fq1)
}
