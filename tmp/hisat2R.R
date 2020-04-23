library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

fastq_file <- args[1]
out_path <- args[2]º

hisat2R(threads = threads,
        fastq_file = fastq_file,
        out_path = out_path)



