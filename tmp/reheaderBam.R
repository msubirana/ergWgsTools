library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'

args <- commandArgs(trailingOnly = TRUE)

bam <- args[1]
out_path <- args[2]

reheaderBam(bam = bam,
            out_path = ref)
