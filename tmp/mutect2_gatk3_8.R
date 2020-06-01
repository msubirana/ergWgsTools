library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
args <- commandArgs(trailingOnly = TRUE)

tumor <- args[1]
normal <- args[2]
output <- args[3]

# mutect2 calling
mutect2_gatk3_8(tumor=tumor,
                normal=normal,
                output=output)

