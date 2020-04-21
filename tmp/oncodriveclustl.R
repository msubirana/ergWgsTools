devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()
cores <- threads/2
args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
regions <- args[2]
output_dir <- args[3]

oncodriveclustl(input=input,
                regions=regions,
                output_dir=output_dir,
                cores=cores)







