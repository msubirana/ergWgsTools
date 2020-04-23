#' hisat2R
#'
#'@description
#' Parser of HISAT2 for R
#'
#'@usage
#'hisat2R(threads, type, index, fastq_file, out_path)
#'
#'@param fastq_file Fastq to demultiplex.
#'In paired-end file used should be R1 and following the format "file_R1.*"
#'@param type "single" or "paired" format
#'@param out_path Path where to save the demultiplex output
#'@param index HISAT2 reference genome index
#'
#'@examples
#'threads <- 2
#'index <- '/imppc/labs/lplab/share/marc/refgen/hg38/HISAT2/hg38.tar.gz'
#'fastq_file <- '/imppc/labs/lplab/share/Insulinoma/raw/NET20_INS_RNA_1.fq.gz'
#'out_path <- '/imppc/labs/lplab/share/Insulinoma/raw/proves'
#'type <- 'paired'
#'
#'hisat2R(threads, type, index, fastq_file, out_path)
#'@export

hisat2R <- function(hisat2 = 'hisat2',
                    sambamba = 'sambamba',
                    samblaster = 'samblaster',
                    threads = 2,
                    type = 'paired',
                    index = '/imppc/labs/lplab/share/marc/refgen/hg38/HISAT2/hg38/genome',
                    fastq_file,
                    out_path){

  message(paste('Starting HISAT2 alignment using:\n',
                'Threads:', threads, "\n",
                'File:', fastq_file, '\n',
                'Type:', type, '\n',
                'Output path:', out_path))

  if(type == 'single'){
    file_name <- gsub("\\..*$", "", basename(file_R1))
    out_bam <- file.path(out_path, paste0(file_name, ".bam"))

    system(paste(hisat2,
                 '-p', threads,
                 '-q', #fastq as input
                 '-x', index,
                 '-1', file_R1, '|',
                 samblaster, '|', #markdupl
                 sambamba, 'view', #samtoBam
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 sambamba, 'sort',
                 '-t', threads,
                 '--tmpdir', out_path,
                 '-o', out_bam,
                 '/dev/stdin ;',
                 sambamba, 'index', #index bam
                 "-t", threads,
                 out_bam))
  }

  if(type == 'paired'){

    file_R1 <- fastq_file
    file_R2 <- gsub('_R1', '_R2', fastq_file)

    file_name <- gsub("\\..*$", "", basename(file_R1))
    file_name <- gsub("_R1", "", file_name)

    out_bam <- file.path(out_path, paste0(file_name, ".bam"))

    system(paste(hisat2,
                 '-p', threads,
                 '-q', #fastq as input
                 '-x', index,
                 '-1', file_R1,
                 '-2', file_R2, '|',
                 'samblaster |', #markdupl
                 'sambamba view', #samtoBam
                 '-t', threads, '-S',
                 '-f bam /dev/stdin |',
                 'sambamba sort',
                 '-t', threads,
                 '--tmpdir', out_path,
                 '-o', out_bam,
                 '/dev/stdin ;',
                 "sambamba index", #index bam
                 "-t", threads,
                 out_bam))

  }

  message(paste('Finished HISAT2 alignment using:\n',
                'Threads:', threads, "\n",
                'File:', fastq_file, '\n',
                'Type:', type, '\n',
                'Output path:', out_path))
}

