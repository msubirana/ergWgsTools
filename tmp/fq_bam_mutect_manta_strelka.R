library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
threads <- parallel::detectCores()

args <- commandArgs(trailingOnly = TRUE)

bam_BL <- args[1]
out_path <- args[2]

bam_TI <- gsub('_BL', '_TI', bam_BL)
out_path_fq <- file.path(out_path, 'fq')
dir.create(out_path_fq, showWarnings = FALSE)

bamTofastqPicard(bam = bam_BL,
                 ref = ref,
                 out_path = out_path_fq,
                 threads = threads)

bamTofastqPicard(bam = bam_TI,
                 ref = ref,
                 out_path = out_path_fq,
                 threads = threads)

name_non_ext <- basename(tools::file_path_sans_ext(bam_BL))
fastq_BL <- file.path(out_path_fq, paste0(name_non_ext, "_R1.fq.gz"))
out_path_realigned <- file.path(out_path, 'realigned')
dir.create(out_path_realigned, showWarnings = FALSE)

bwaAlignment(fastq = fastq_BL,
             ref = ref,
             out_path = out_path_realigned,
             threads = threads)

unlink(fastq_BL)
unlink(gsub('R1', 'R2', fastq_BL))

name_non_ext <- basename(tools::file_path_sans_ext(bam_TI))
fastq_TI <- file.path(out_path_fq, paste0(name_non_ext, "_R1.fq.gz"))
out_path_realigned <- file.path(out_path, 'realigned')
dir.create(out_path_realigned, showWarnings = FALSE)

bwaAlignment(fastq = fastq_TI,
             ref = ref,
             out_path = out_path_realigned,
             threads = threads)

unlink(fastq_TI)
unlink(gsub('R1', 'R2', fastq_TI))

tumor_file <- file.path(out_path_realigned, basename(bam_TI))
normal_file <- file.path(out_path_realigned, basename(bam_BL))
sample_name <- gsub("_.*", '', basename(bam_TI))

out_path_calling <- file.path(out_path, 'calling')
dir.create(out_path_calling, showWarnings = FALSE)

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
               out_path = out_path_calling,
               gatk4 = gatk4,
               threads = threads,
               af_only_gnomad = af_only_gnomad,
               bcftools = bcftools)

# manta calling
mantaCalling(tumor_file = tumor_file,
             normal_file = normal_file,
             sample_name = sample_name,
             ref = ref,
             out_path = out_path_calling,
             manta = manta,
             threads = threads)

# Strelka2 calling
strelka2Calling(tumor_file = tumor_file,
                normal_file = normal_file,
                sample_name = sample_name,
                ref = ref,
                out_path = out_path_calling,
                threads = threads,
                indel_candidates = file.path(out_path_calling, 'manta', paste0(sample_name, "_out_manta"),
                                             'results/variants/candidateSmallIndels.vcf.gz'),
                strelka2 = strelka2,
                bcftools = bcftools)



