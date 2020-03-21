source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

samblaster = 'samblaster'
sambamba = 'sambamba'
samtools = 'samtools'
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2'
strelka2 <- '/soft/bio/strelka-2.9.3'
bcftools <- 'bcftools'
manta <- '/software/debian-8/bio/manta-1.4.0'

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

# manta calling
mantaCalling(tumor_file = tumor_file,
             normal_file = normal_file,
             sample_name = sample_name,
             ref = ref,
             out_path = out_path,
             manta = manta,
             threads = threads)

# Strelka2 calling
strelka2Calling(tumor_file = tumor_file,
                normal_file = normal_file,
                sample_name = sample_name,
                ref = ref,
                out_path = out_path,
                threads = threads,
                indel_candidates = file.path(out_path, 'manta', paste0(sample_name, "_out_manta"),
                                             'results/variants/candidateSmallIndels.vcf.gz'),
                strelka2 = strelka2,
                bcftools = bcftools)

# unlink(tumor_file)
# unlink(normal_file)
# unlink(paste0(tumor_file, '.bai'))
# unlink(paste0(normal_file, '.bai'))
