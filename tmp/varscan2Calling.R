source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

# check BAM indexes
sambambaIndex(bam = tumor_file,
              threads = threads)

sambambaIndex(bam = normal_file,
              threads = threads)

# VarScan2 calling
varscan2Calling(tumor_file = tumor_file,
                normal_file = normal_file,
                sample_name = sample_name,
                ref = ref,
                out_path = out_path,
                varscan2 = varscan2,
                samtools = samtools,
                fpfilter = fpfilter,
                perl = perl,
                bcftools = bcftools)


