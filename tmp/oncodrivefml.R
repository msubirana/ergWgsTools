devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
elements <- args[2]
output_dir <- args[3]
configuration <- args[4]

oncodrivefml(input=input,
             elements=elements,
                output_dir=output_dir,
             configuration=configuration)







