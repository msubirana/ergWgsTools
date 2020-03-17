#' renameSampleBam
#'
#' @description
#' Rename sample name of a BAM using samtools.
#' Input folder and output folder should be different for avoding overwrite problems.
#'
#' @inheritParams somaticWgsAnalysis
#' @param new_sample_name New sample name for the BAM file
#' @examples
#' \dontrun{
#' renameSampleBam(bam = 'sample.bam',
#'                 samtools = 'samtools',
#'                 new_sample_name = 'new_sm',
#'                 out_path = 'bam/renamed')
#'}
#'
#' @export
renameSampleBam <- function(bam,
                            samtools = 'samtools',
                            new_sample_name,
                            out_path){

  renamed_bam <- file.path(out_path, basename(bam))

  message(paste(Sys.time(),"\n",
                'Starting renaming BAM file using:\n',
                '>BAM file:', bam, '\n',
                '>New sample name:', new_sample_name, '\n',
                '>Output path:', out_path, '\n'))

  # rename using samtools reheader
  system(paste(samtools,
               'view -H', bam,
               '| sed',
               paste0('"s/SM:[^\t]*/SM:', new_sample_name, '/g"'),
               '|', samtools, 'reheader -', bam,
               '>', renamed_bam))

  message(paste(Sys.time(),"\n", 'Finished', bam, '\n'))
}
