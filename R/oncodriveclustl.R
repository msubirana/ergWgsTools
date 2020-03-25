#' oncodriveclustl
#'
#' @description
#' Parser for oncodriveclustl
#' @param input File containing mutations
#' @param regions GZIP compressed file with the genomic regions to analyze
#' @param output_dir Output directory to be created
#' @param genome Genome to use. Default is hg38.
#' @param cores Cores to use in the analysis.
#' @examples
#' \dontrun{
#' oncodriveclustl(input = 'all_ins.tvs', regions = 'regions.regions', output_dir = 'rst/', genome = 'hg38', cores = 2)
#' }
#'
#' @export

oncodriveclustl <- function(input,
                   regions,
                   output_dir,
                   genome = 'hg38',
                   cores){

  message(paste(Sys.time(),"\n",
                'Starting oncodriveclustl using:\n',
                input, 'as a input file\n',
                regions, 'as a regions file\n',
                output_dir, 'as a output directory\n',
                genome, 'as genome\n',
                cores, 'as cores used'))

  # activate venv
  #system('source /software/debian-8/general/virtenvs/oncodriveCLUSTL-v1.1.1-py3/bin/activate')

  # run oncodriveclustl
  system(paste('oncodriveclustl',
               '-i', input,
               '-r', regions,
               '-o', output_dir,
               '-g', genome,
               '-c', cores))

  message(paste(Sys.time(),"\n",
                'Finished oncodriveclustl using:\n',
                input, 'as a input file\n',
                regions, 'as a regions file\n',
                output_dir, 'as a output directory\n',
                genome, 'as genome\n'))
}

