devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()
cores <- threads/2
args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
regions <- args[2]
output_dir <- args[3]
sm <- args[4]
simw <- args[5]
cw <- args[6]

message(sm)
message(simw)
message(cw)

# oncodriveclustl(input=input,
#                 regions=regions,
#                 output_dir=output_dir,
#                 cores=cores,
#                 sw=sw,
#                 simw=simw,
#                 cw=cw)







