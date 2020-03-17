#' postAlignment
#'
#' @description
#' Local realignment of insertions and deletions is performed using GATK IndelRealigner and
#' a base quality score recalibration (BQSR) step performed using GATK BaseRecalibrator.
#' Local realigment of INDELs locates regions that contain misalignments across BAM files,
#' which can often be caused by insertion-deletion (indel) mutations with respect to the reference genome.
#' BQSR adjusts base quality scores based on detectable and systematic errors.
#'
#' @param input_file Fastq file to align. If paried-end type, `input_file` have to contain mate 1s and different pairs should
#'  be named "_R1" or "_R2". Allowed formats: fastq.gz, fq.gz, fastq, fq or bam.
#' @param threads Number of threads to use in the analysis.
#' @param ref Path for the reference genome to use for the alignment (fasta format) and the corresponding indexes
#' generated with bwa index.
#' @param out_path Path where the output of the analysis will be saved.
#' @param gatk4 Path of GATK4 binary
#' @param known_sites Vector object with the GATK databases of known polymorphic sites
#' used to exclude regions around known polymorphisms from analysis. They have to be based on the same reference genome as `ref`.
#' #' @examples
#' \dontrun{
#' postAlignment(input_file = 'raw/sample.bam',
#'              ref = ref/hg38.fa',
#'              out_path = 'rst',
#'              threads = '2')
#'}
#'
#' @export

postAlignment <- function(input_file,
                          ref,
                          out_path,
                          threads,
                          gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
                          known_sites = c('/imppc/labs/lplab/share/marc/refgen/hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf')){

  message(paste(Sys.time(),"\n",
                'Starting GATK BQSR alignment using:\n',
                '>Input file:', input_file, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_path, '\n',
                '>Number of threads:', threads, '\n',
                '>Known sites:', paste(known_sites, collapse = " ")))

  sample_name <- gsub("\\..*$", "", basename(input_file))

  recal_data_table1 <- file.path(out_path, paste0(sample_name, "_recal_data1.table"))
  recal_data_table2 <- file.path(out_path, paste0(sample_name, "_recal_data2.table"))

  # BaseRecalibrator builds the model

  system(paste(gatk4,
               '--java-options', paste0('-XX:ParallelGCThreads=', threads),
               'BaseRecalibrator',
               '-I', input_file,
               paste('--known-sites', known_sites, collapse = " "),
               '-O', recal_data_table1,
               '-R', ref))

  # ApplyBQSR adjusts the scores

  system(paste(gatk4,
               '--java-options', paste0('-XX:ParallelGCThreads=', threads),
               'ApplyBQSR',
               '-I', input_file,
               '-R', ref,
               '-O', file.path(out_path, paste0(sample_name, ".bam"))))

  system(paste(gatk4,
               '--java-options', paste0('-XX:ParallelGCThreads=', threads),
               'BaseRecalibrator',
               '-I', file.path(out_path, paste0(sample_name, ".bam")),
               paste('--known-sites', known_sites, collapse = " "),
               '-O', recal_data_table2,
               '-R', ref))

  # Evaluate and compare base quality score recalibration tables

  system(paste(gatk4,
               '--java-options', paste0('-XX:ParallelGCThreads=', threads),
               'AnalyzeCovariates',
               '--before', recal_data_table1,
               '--after', recal_data_table2,
               '-plots', file.path(out_path, paste0(sample_name, "_AnalyzeCovariates.pdf"))))

  message(paste('Finished', sample_name))

}

