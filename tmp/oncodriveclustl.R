devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
regions <- args[2]
output_dir <- args[3]
sw <- args[4]
simw <- args[5]
cw <- args[6]
cores <- args[7]

oncodriveclustl(input=input,
                regions=regions,
                output_dir=output_dir,
                cores=cores,
                sw=sw,
                simw=simw,
                cw=cw)







