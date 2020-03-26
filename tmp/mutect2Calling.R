source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

tumor_file <- args[1]
normal_file <- args[2]
sample_name <- args[3]
out_path <- args[4]

# check BAM indexes
sambambaIndex(bam = tumor_file,
              threads = threads,
              sambamba = sambamba)

sambambaIndex(bam = normal_file,
              threads = threads,
              sambamba = sambamba)

# mutect2 calling
mutect2Calling(tumor_file = tumor_file,
               normal_file = normal_file,
               sample_name = sample_name,
               ref = ref,
               out_path = out_path,
               gatk4 = gatk4,
               threads = threads,
               af_only_gnomad = af_only_gnomad,
               bcftools = bcftools)
