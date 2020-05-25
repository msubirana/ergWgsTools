library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

bam <- args[1]
out_path <- args[2]
cores <- args[3]

threads <- cores * 2

bamTofastqPicard(bam = bam,
                 ref = ref,
                 out_path = out_path,
                 threads = threads)

name_non_ext <- basename(tools::file_path_sans_ext(bam))
fastq <- file.path(out_path, paste0(name_non_ext, "_R1.fq.gz"))

bwaAlignment(fastq = fastq,
             ref = ref,
             out_path = out_path,
             threads = threads)



