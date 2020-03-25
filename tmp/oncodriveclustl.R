devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()
cores <- threads/2

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
regions <- args[2]
output_dir <- args[3]
genome <- args[4]

oncodriveclustl(input,
                regions,
                output_dir,
                genome = 'hg38',
                cores)







