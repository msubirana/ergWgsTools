threads <- parallel::detectCores()

fastqc <- 'fastqc'
args <- commandArgs(trailingOnly = TRUE)
fq <- args[1]
fq_path <- args[2]

system(paste(fastqc,
             fq,
             '-t', threads,
             '-o', fq_path)
)

