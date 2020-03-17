library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

threads <- parallel::detectCores()
tumor_file <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/to_do/NET-10_TI.bam'
normal_file <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/to_do/NET-10_BL.bam'
sample_name <- 'NET-10'
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/calling_ergWgsTools'


# variantCalling(tumor_file = tumor_file,
#                normal_file = normal_file,
#                sample_name = sample_name,
#                ref = ref,
#                out_path = out_path,
#                threads = threads)

# other variables

gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk'
muse = '/imppc/labs/lplab/share/marc/repos/MuSE/MuSE'
bwa = 'bwa'
samblaster = 'samblaster'
sambamba = 'sambamba'
samtools = 'samtools'
somatic_sniper = '/imppc/labs/lplab/share/marc/repos/somatic-sniper/build/bin/bam-somaticsniper'
varscan2 = '/imppc/labs/lplab/share/marc/repos/varscan/VarScan.v2.4.4.jar'
manta = '/software/debian-8/bio/manta-1.4.0'
strelka2 = '/soft/bio/strelka-2.9.3'
af_only_gnomad = '/imppc/labs/lplab/share/marc/refgen/hg38/af-only-gnomad.hg38.vcf.gz'
pindel = '/soft/bio/pindel/pindel'
centromeres_telomeres = '/imppc/labs/lplab/share/marc/refgen/hg38/centromeres.bed'
perl = 'perl'
python_radia = '/imppc/labs/lplab/share/marc/repos/miniconda/bin/python2.7'
radia_path = '/imppc/labs/lplab/share/marc/repos/radia/scripts'
bcftools = 'bcftools'
tumor_vcf_id = 'TUMOR'
fpfilter = '/imppc/labs/lplab/share/marc/repos/fpfilter-tool/fpfilter.pl'
bam_readcount = 'bam-readcount'

# # MuSE calling
# museCalling(tumor_file = tumor_file,
#             normal_file = normal_file,
#             sample_name = sample_name,
#             ref = ref,
#             out_path = out_path,
#             muse = muse,
#             af_only_gnomad = af_only_gnomad,
#             bcftools = bcftools)


# # VarScan2 calling
# varscan2Calling(tumor_file = tumor_file,
#                 normal_file = normal_file,
#                 sample_name = sample_name,
#                 ref = ref,
#                 out_path = out_path,
#                 varscan2 = varscan2,
#                 samtools = samtools,
#                 fpfilter = fpfilter,
#                 perl = perl,
#                 bcftools = bcftools)

# # Pindel calling
# pindelCalling(tumor_file = tumor_file,
#               normal_file = normal_file,
#               sample_name = sample_name,
#               ref = ref,
#               out_path = out_path,
#               pindel = pindel,
#               sambamba = sambamba,
#               samtools = samtools,
#               threads = threads,
#               perl = perl,
#               gatk4 = gatk4,
#               centromeres_telomeres = centromeres_telomeres,
#               bcftools = bcftools)
#
# # manta calling
# mantaCalling(tumor_file = tumor_file,
#              normal_file = normal_file,
#              sample_name = sample_name,
#              ref = ref,
#              out_path = out_path,
#              manta = manta,
#              threads = threads)
#
# # Strelka2 calling
# strelka2Calling(tumor_file = tumor_file,
#                 normal_file = normal_file,
#                 sample_name = sample_name,
#                 ref = ref,
#                 out_path = out_path,
#                 threads = threads,
#                 indel_candidates = file.path(out_path, 'manta', paste0(sample_name, "_out_manta"),
#                                              'results/variants/candidateSmallIndels.vcf.gz'),
#                 strelka2 = strelka2,
#                 bcftools = bcftools)
#
#
# # MuTect2 calling
# mutect2Calling(tumor_file = tumor_file,
#                normal_file = normal_file,
#                sample_name = sample_name,
#                ref = ref,
#                out_path = out_path,
#                gatk4 = gatk4,
#                threads = threads,
#                af_only_gnomad = af_only_gnomad,
#                bcftools = bcftools)
#
# # RADIA calling
# radiaCalling(tumor_file = tumor_file,
#              normal_file = normal_file,
#              sample_name = sample_name,
#              ref = ref,
#              out_path = out_path,
#              radia_path = radia_path,
#              python_radia = python_radia,
#              samtools = samtools,
#              threads = threads,
#              bcftools = bcftools)
#
# Somatic Sniper calling
# somaticsniperCalling(tumor_file = tumor_file,
#                      normal_file = normal_file,
#                      sample_name = sample_name,
#                      ref = ref,
#                      out_path = out_path,
#                      somatic_sniper = somatic_sniper,
#                      fpfilter = fpfilter,
#                      perl = perl,
#                      bcftools = bcftools)


# # test subset
# library(devtools)
# devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
# threads <- parallel::detectCores()
# threads <- threads - 2
# tumor_file <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/bam/NET-10_TI_mkdup_sub_0005.bam'
# normal_file <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/bam/NET-10_BL_mkdup_sub_0005.bam'
# sample_name <- 'NET-10'
# ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
# out_path <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/vcf'
# #
# variantCalling(tumor_file = tumor_file,
#                normal_file = normal_file,
#                sample_name = sample_name,
#                ref = ref,
#                out_path = out_path,
#                threads = threads)

vcf <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/calling_ergWgsTools/strelka2/NET-10_out_strelka2/results/variants/NET-10_out_strelka2_snvs_postCalling.vcf'
out_path <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/vcf/vep_annotation'
cache_dir <- '/imppc/labs/lplab/share/marc/refgen/hg38'
sample_name <- gsub(".vcf", "", basename(vcf))
annotated_vcf <- file.path(out_path, paste0(sample_name, '_vep_annotated.vcf'))
perl <- 'perl'
vcf_maf <- '/imppc/labs/lplab/share/marc/repos/vcf2maf/vcf2maf.pl'
vep_path <- '/imppc/labs/lplab/share/marc/repos/ensembl-vep'
tumor_id <- 'NET-10_TI_muse'
normal_id <- 'NET-10_BL_muse'
vcf_tumor_id <- 'TUMOR'
vcf_normal_id <- 'NORMAL'
maf <- gsub('\\..*$', '.maf', vcf)
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
bcftools <- 'bcftools'

#
# filter chr from vcf
regions_chr <- paste(paste0('chr', seq_len(22), collapse = ","), 'chrY', 'chrX', collapse = ",")

# vcf <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/vcf/mutec2/NET-10_mutec2.vcf'
# vcf <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/vcf/pindel/NET-10_somatic.vcf'
# system(paste('bgzip -c', vcf, '>', paste0(vcf, '.gz') ))
# system(paste('tabix', paste0(vcf, '.gz')))
#
# vcf_filtered <- paste0(gsub("\\..*$", "", vcf), "_filtered.vcf")
#
# system(paste(bcftools, 'view',
#              paste0(vcf, '.gz'),
#              '--regions', regions_chr,
#              '>', vcf_filtered))

system(paste(perl, vcf_maf,
             '--input', vcf,
             '--output-maf', maf,
             '--tumor-id', tumor_id,
             '--normal-id', normal_id,
             '--ref-fasta', ref,
             '--vcf-tumor-id', vcf_tumor_id,
             '--vcf-normal-id', vcf_normal_id,
             '--vep-path', vep_path,
             '--vep-data', cache_dir,
             '--filter-vcf', 0,
             '--ncbi-build GRCh38'))
