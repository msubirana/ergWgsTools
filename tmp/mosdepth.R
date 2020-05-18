source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

inputFile <- args[1]
outPath <- args[2]
threads <- args[3]

mosdepth(inputFile=inputFile,
         threads=threads,
         outPath=outPath)
