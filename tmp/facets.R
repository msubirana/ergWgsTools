source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

normal <- args[1]
tumor <- args[2]
outName <- args[3]
outPath <- args[4]

facets(normal=normal,
       tumor=tumor,
       outName=outName,
       outPath=outPath)
