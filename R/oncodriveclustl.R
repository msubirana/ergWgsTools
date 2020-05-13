#' oncodriveclustl
#'
#' @description
#' Parser for oncodriveclustl
#' @param input File containing mutations
#' @param regions GZIP compressed file with the genomic regions to analyze
#' @param output_dir Output directory to be created
#' @param genome Genome to use. Default hg38.
#' @param cores Cores to use in the analysis.
#' @param kmer K-mer nucleotide context. Default 5.
#' @param sigcalc Signature calculation: mutation frequencies (frequencies) or k-mer mutation counts
#' normalized by k-mer region counts (region_normalized). Default region_normalized
#' @param sw Smoothing window. Default is 11
#' @param cw Cluster window. Default is 11
#' @param simw Simulation window. Default is 31
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
                   cores = 2,
                   kmer = 5,
                   sigcalc = 'region_normalized',
                   sw = 11,
                   simw = 31,
                   cw = 11){

  message(paste(Sys.time(),"\n",
                'Starting oncodriveclustl using:\n',
                input, 'as a input file\n',
                regions, 'as a regions file\n',
                output_dir, 'as a output directory\n',
                genome, 'as genome\n',
                cores, 'as cores used',
                sw, 'as smoothing window',
                cw, 'as cluster window',
                simw, 'as simulation window'))

  # run oncodriveclustl
  system(paste('oncodriveclustl',
               '-i', input,
               '-r', regions,
               '-o', output_dir,
               '-g', genome,
               '-c', cores,
               '--qqplot',
               '-kmer', kmer,
               '-sigcalc', sigcalc,
               '-sw', sw,
               '-simw', simw,
               'cw', cw))

  message(paste(Sys.time(),"\n",
                'Finished oncodriveclustl using:\n',
                input, 'as a input file\n',
                regions, 'as a regions file\n',
                output_dir, 'as a output directory\n',
                genome, 'as genome\n'))
}

