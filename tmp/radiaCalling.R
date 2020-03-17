source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

# check BAM indexes
sambambaIndex(bam = tumor_file,
              threads = threads)

sambambaIndex(bam = normal_file,
              threads = threads)

# RADIA calling
radiaCalling(tumor_file = tumor_file,
             normal_file = normal_file,
             sample_name = sample_name,
             ref = ref,
             out_path = out_path,
             radia_path = radia_path,
             python_radia = python_radia,
             samtools = samtools,
             threads = threads,
             bcftools = bcftools)
