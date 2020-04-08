library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

fastq <- args[1]
out_path <- args[2]
type_input_file <- args[3]

bwaAlignment(input_file = fastq,
             ref = ref,
             out_path = out_path,
             threads = threads,
             type_input_file = type_input_file)



