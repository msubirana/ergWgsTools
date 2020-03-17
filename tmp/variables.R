# define variables
tumor_file <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/to_do/NET-10_TI.bam'
normal_file <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/to_do/NET-10_BL.bam'
sample_name <- 'NET-10'
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/calling_ergWgsTools2'
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


# library(devtools)
# devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
#
# bams <- list.files('/media/msubirana/IGTP20228/insulinomas/processed/hg38/bam/bwa',
#            pattern = ".bam$",
#            full.names = TRUE)
# out_path <- '/media/msubirana/IGTP20228/insulinomas/processed/hg38/bam/bwa/renamed'
#
# for(bam in bams){
#   reheaderBam(bam = bam,
#               out_path = out_path)
# }


