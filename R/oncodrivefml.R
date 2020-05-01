#' oncodrivefml
#'
#' @description
#' Parser for oncodrivefml.
#' @param input File containing mutations
#' @param elements GZIP compressed file with the genomic elements to analyze
#' @param output_dir Output directory to be created
#' @param sequencing Type of sequencing. Allowd 'wgs', 'wes'
#' 'targeted'. By default='wgs'.
#' @param configuration Path to configuration file.
#' @examples
#' \dontrun{
#' oncodrivefml(input = 'all_ins.tvs', elements = 'elements.elements', output_dir = 'rst/')
#' }
#'
#' @export

oncodrivefml <- function(input,
                            elements,
                            output_dir,
                          sequencing = 'wgs',
                         configuration){

  message(paste(Sys.time(),"\n",
                'Starting oncodrivefml using:\n',
                input, 'as a input file\n',
                elements, 'as a elements file\n',
                output_dir, 'as a output directory\n',
                sequencing, 'as sequencing\n',
                configuration, 'as configuration file\n'))

  # run oncodrivefml
  system(paste('oncodrivefml',
               '-i', input,
               '-r', elements,
               '-o', output_dir,
               '-s', sequencing,
               '-c',configuration))

  message(paste(Sys.time(),"\n",
                'Finished oncodrivefml'))
}

