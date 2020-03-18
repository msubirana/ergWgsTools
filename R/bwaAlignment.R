#' bwaAlignment
#'
#' @description
#' Aligns FASTQ files using bwa mem and a defined reference genome. It alignes paired or single end data and BAM files. The
#' BAM to FASTQ conversion is carried out by Picard's SamToFastq.
#'
#' @inheritParams somaticWgsAnalysis
#' @param type_input_file Define type of input file (bam or fastq). By default fastq.
#' @examples
#' \dontrun{
#' bwaAlignment(input_file = 'raw/sample_R1.fa',
#'              ref = 'ref/hg38.fa',
#'              out_path = 'rst',
#'              threads = 2)
#' }
#' @export
bwaAlignment <- function(input_file,
                         type_input_file = 'fastq',
                         ref,
                         out_path,
                         threads,
                         gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
                         sambamba = 'sambamba',
                         bwa = 'bwa',
                         samblaster = 'samblaster',
                         samtools = 'samtools'){

    # generate bam index if it is not present
  if(type_input_file == 'bam'){

    system(paste(sambamba, "index",
                 "-t", threads,
                 input_file))
  }

  # bam to fastq
  if(type_input_file == 'bam'){

    input_file <- bamTofastqPicard(input_file,
                                   ref,
                                   out_path,
                                   threads,
                                   gatk4 = gatk4,
                                   sambamba = sambamba)
    }

  # define fastq type
  name_non_ext <- basename(gsub("\\..*", "", (input_file)))
  out_bam <- file.path(out_path, paste0(name_non_ext, ".bam"))
  out_bam <- gsub("_R1", "", out_bam)
  input_file2 <- gsub('R1', 'R2', input_file)

  if(file.exists(input_file2)){
    type <- 'paired'
  } else {
    type <- 'single'
  }


  # align fastq depending on the type
  message(paste(Sys.time(),"\n",
                'Starting bwa mem alignment using:\n',
                '>Input file:', input_file, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_path, '\n',
                '>Number of threads:', threads, '\n'))

  if (type == 'single'){

    system(paste(bwa, 'mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", "\\tPU:1\\tSM:", "\\tPL:ILLUMINA\""),
                 ref,
                 input_file, "|",
                 samblaster, '-M |',
                 sambamba, 'view',
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 samtools,'sort', # memmory problems with sambamba sort
                 #'-n', # sort by names
                 '-@', threads,
                 '-o', out_bam, ';',
                 sambamba, "index",
                 "-t", threads,
                 out_bam))

  } else if (type == 'paired'){

    system(paste(bwa, 'mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", "\\tPU:1\\tSM:", "\\tPL:ILLUMINA\""),
                 ref,
                 input_file, input_file2, "|",
                 samblaster, '-M |',
                 sambamba, 'view',
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 samtools,'sort', # memmory problems with sambamba sort
                 #'-n', # sort by names
                 '-@', threads,
                 '-o', out_bam, ';',
                 sambamba, "index",
                 "-t", threads,
                 out_bam))
  }

  sample_name <- gsub("\\..*$", "", basename(input_file))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}

#' bamTofastqPicard
#'
#' This function converts BAM files to FASTQ files using GATK4 SamToFastq. Type of BAM file (paried or single) is detected
#' automatically.
#'
#' @inheritParams somaticWgsAnalysis
#'
#' @examples
#' \dontrun{
#' bamTofastqPicard(input_file = 'raw/sample.bam',
#'              ref = 'ref/hg38.fa',
#'              out_path = 'rst',
#'              threads = '2')
#' }
#' @export
bamTofastqPicard <- function(input_file,
                             ref,
                             out_path,
                             threads,
                             gatk4,
                             sambamba){

  name_non_ext <- basename(tools::file_path_sans_ext(input_file))

  # define type of bam
  sam_type <- system(paste(sambamba, 'view',
                          '-t', threads,
                          '-c -f 1', input_file), intern = T)
  sam_type <- as.numeric(sam_type)


  if (sam_type > 0){
    type = 'paired'
  } else if (sam_type == 0){
    type = 'single'}

  # if index does not exists, create it
  index <- paste0(input_file, '.bai')

  if(!file.exists(index)){
    system(paste(sambamba, "index",
                 "-t", threads,
                 input_file))
  }

  # realign bam depending on the type
  message(paste(Sys.time(),"\n",
                'Starting BAM to FASTQ conversion using:\n',
                '>Input file:', input_file, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_path, '\n',
                '>Number of threads:', threads))

  if (type == 'single'){

    out_fq <- file.path(out_path, paste0(name_non_ext, ".fq"))
    out_bam <- file.path(out_path, paste0(name_non_ext, ".bam"))

    system(paste(gatk4,
                 '--java-options', paste0('-XX:ParallelGCThreads=', threads),
                 'SamToFastq',
                 "-I", input_file,
                 "-F", out_fq))

    message(paste(Sys.time(),"\n",
                  'Finished', basename(input_file)))

    return(out_fq)

  } else if (type == 'paired'){

    out_fq1 <- file.path(out_path, paste0(name_non_ext, "_R1.fq"))
    out_fq2 <- file.path(out_path, paste0(name_non_ext, "_R2.fq"))
    out_bam <- file.path(out_path, paste0(name_non_ext, ".bam"))

    system(paste(gatk4,
                 '--java-options', paste0('-XX:ParallelGCThreads=',threads),
                 'SamToFastq',
                 "-I", input_file,
                 "-F", out_fq1,
                 "-F2", out_fq2))

  }

  message(paste(Sys.time(),"\n",
                'Finished BAM to FASTQ conversion', input_file, '\n'))

  return(out_fq1)
}


