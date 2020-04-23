#' bamCoverage
#'
#'@description
#' Parser of DeepTools BamCounter for R
#'
#' @param deep_tools Path to the activate file of the deeptools virtual environment
#' @param bam Bam file to generate the bam counts
#' @param cores Number of cores used in the analysis
#' @param out_path Path where to save the output bigWig. It will be saved with the same base
#' name as bam and ".bw" extension.

#'@examples
#'out_path <- '/counts
#'bam <- '/raw/sample.bam
#'
#'bamCoverage(bam, out_path)
#'@export

bamCoverage <- function(deep_tools = '/imppc/labs/lplab/share/bin/anaconda3/bin/activate',
                    bam,
                    cores = 2,
                    out_path){

  message(paste('Starting BamCoverage using:\n',
                'Cores:', cores, "\n",
                'Bam:', bam, '\n',
                'Output path:', out_path))

  system(paste('source', deep_tools))

  sample_name <- gsub("\\..*$", '', basename(bam))

  bigwig <- file.path(out_path, paste0(sample_name, '.bw'))

  system(paste('bamCoverage',
               '-b', bam,
               '-o', bigwig,
               '-of', 'bigwig',
               '-p', cores))

  message(paste('Finished', sample_name))



}

