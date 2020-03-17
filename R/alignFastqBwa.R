#' alignFastqBwa
#'
#' This function aligns fq files using a defined reference genome and bwa being possible to
#' use paired or single end data
#'
#' @param input_file Fastq file to align (in paired use R1)
#' @param threads Number of threads to use in the analysis.
#' @param ref Path where the reference genome is save..
#' @param out_path Path where the output of the analysis will be saved.
#'
#' @examples
#' \dontrun{
#' input_file <- 'raw/sample_R1.fa'
#' ref <- 'ref/hg38.fa'
#' out_path <- 'rst'
#' threads <- 2
#'
#' alignFastqBwa(input_file, ref, out_path, threads, removeOpt)
#'}
#'
#' @export

alignFastqBwa <- function(input_file,
                          ref,
                          out_path,
                          threads){


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
                'Starting aligning using:\n',
                type, 'as fastq type\n',
                input_file, 'as a fq\n',
                ref, 'as reference genome\n',
                out_path, 'as output path\n'))

  if (type == 'single'){

    system(paste('bwa mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", "\\tPU:1\\tSM:", "\\tPL:ILLUMINA\""),
                 ref,
                 input_file, "|",
                 'samblaster -M |',
                 'sambamba view',
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 'samtools sort',
                 '-n', # sort by names
                 '-@', threads,
                 '-o', out_bam, ';',
                 "sambamba index",
                 "-t", threads,
                 out_bam))

  } else if (type == 'paired'){

    input_file2 <- gsub('R1', 'R2', input_file)

    system(paste('bwa mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", "\\tPU:1\\tSM:", "\\tPL:ILLUMINA\""),
                 ref,
                 input_file, input_file2, "|",
                 'samblaster -M |',
                 'sambamba view',
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 'sambamba sort',
                 '-t', threads,
                 '--tmpdir', out_path,
                 '-o', out_bam,
                 '/dev/stdin ;',
                 "sambamba index",
                 "-t", threads,
                 out_bam))
  }
}
