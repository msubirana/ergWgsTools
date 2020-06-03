fastqc <- 'fastqc'
args <- commandArgs(trailingOnly = TRUE)
file <- args[1]
out_path <- args[2]
cores  <- args[3]

threads <- as.numeric(cores) * 2

system(paste(fastqc,
             file,
             '-t', threads,
             '-o', out_path)
)

