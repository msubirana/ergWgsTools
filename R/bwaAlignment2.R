#' bwaAlignment
#'
#' @description
#' Aligns FASTQ files using bwa mem and a defined reference genome. It alignes fastq paired or single end data. The
#' BAM to FASTQ conversion can be carried out using bamTofastqPicard function.
#'
#' @inheritParams somaticWgsAnalysis
#' @examples
#' \dontrun{
#' bwaAlignment(fastq = 'raw/sample_R1.fa',
#'              ref = 'ref/hg38.fa',
#'              out_path = 'rst',
#'              threads = 2)
#' }
#' @export
bwaAlignment2 <- function(fastq,
                          ref,
                          out_path,
                          threads,
                          bwa = 'bwa',
                          gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
                          samtools = 'samtools'){

  # define fastq type
  name_non_ext <- basename(gsub("\\..*", "", (fastq)))
  sm_name <- gsub('_R1', '', name_non_ext)
  out_bam <- file.path(out_path, paste0(name_non_ext, "_tmp.bam"))
  out_bam <- gsub("_R1", "", out_bam)
  mk_dup_bam <- file.path(out_path, paste0(name_non_ext, ".bam"))
  mk_dup_bam <- gsub("_R1", "", out_bam)
  metrics_log <- file.path(out_path, paste0(name_non_ext, "_mkdupl.log"))
  metrics_log <- gsub("_R1", "", out_bam)
  fastq2 <- gsub('R1', 'R2', fastq)

  if(file.exists(fastq2)){
    type <- 'paired'
  } else {
    type <- 'single'
  }

  # align fastq depending on the type
  message(paste(Sys.time(),"\n",
                'Starting bwa mem alignment using:\n',
                '>Input file:', fastq, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_path, '\n',
                '>Number of threads:', threads, '\n'))

  if (type == 'single'){

    system(paste(bwa, 'mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", sm_name, "\\tPU:1\\tSM:", sm_name, "\\tPL:ILLUMINA\""),
                 ref,
                 fastq, "|",
                 samtools, 'view',
                 '-@', threads,
                 '-Shu - |',
                 samtools,'sort',
                 '-@', threads,
                 '-o', out_bam, ';',
                 samtools, "index",
                 '-@', threads,
                 out_bam))



  } else if (type == 'paired'){

    system(paste(bwa, 'mem -M',
                 '-t', threads,
                 paste0("-R \"@RG\\tID:", sm_name, "\\tPU:1\\tSM:", sm_name, "\\tPL:ILLUMINA\""),
                 ref,
                 fastq, fastq2, "|",
                 samtools, 'view',
                 '-@', threads,
                 '-Shu - |',
                 samtools,'sort',
                 '-@', threads,
                 '-o', out_bam, ';',
                 samtools, "index",
                 '-@', threads,
                 out_bam))

  }

  # markduplicates

  system(paste(gatk, 'MarkDuplicates',
               '-I', out_bam,
               '-M', metrics_log,
               '-O', mk_dup_bam))

  sample_name <- gsub("\\..*$", "", basename(fastq))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}


