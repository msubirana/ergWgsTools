library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

bam <- args[1]
out_path <- args[2]

bamTofastqPicard(bam = bam,
                 ref = ref,
                 out_path = out_path,
                 threads = threads)




