source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

bam <- args[1]

samtoolsIndex(bam = bam,
              threads = threads,
              samtools = samtools)
