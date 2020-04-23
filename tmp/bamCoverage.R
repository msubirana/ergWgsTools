library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()
cores <- threads/2
args <- commandArgs(trailingOnly = TRUE)

bam <- args[1]
out_path <- args[2]

bamCoverage(cores = cores,
        bam = bam,
        out_path = out_path)



