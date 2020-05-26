devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
args <- commandArgs(trailingOnly = TRUE)
bam <- args[1]
cores <- args[2]
out_dir <- args[3]

# variables
threads <- as.numeric(cores) * 2
refgen <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
control <- bam
tumor <- gsub('_BL','_TI',bam)
samtools <- 'samtools'
sample_name <- gsub('_BL.bam','',basename(bam))
# bams and names
rg <- system(paste('samtools',
                   'view -H',
                   control), intern = T)
rg <- rg[grepl('@RG\tID', rg)]
rg <- unlist(strsplit(rg, "\t"))
control_name <- rg[grepl('SM:', rg)]
control_name <- gsub('SM:','',control_name)

rg <- system(paste('samtools',
                   'view -H',
                   tumor), intern = T)
rg <- rg[grepl('@RG\tID', rg)]
rg <- unlist(strsplit(rg, "\t"))
tumor_name <- rg[grepl('SM:', rg)]
tumor_name <- gsub('SM:','',tumor_name)

#out dirs
output_dir_cobalt <- file.path(out_dir, 'cobalt')
output_dir_amber <- file.path(out_dir, 'amber')
output_dir_purple <- file.path(out_dir, 'purple')

#strelka
strelka_snvs <- paste0('/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw/',
                       sample_name, '_out_strelka2/results/variants/somatic.snvs.vcf.gz')

strelka_indels <- paste0('/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/strelka2/raw/',
                         sample_name, '_out_strelka2/results/variants/somatic.indels.vcf.gz')

strelka_merged <- file.path(out_dir, 'strelka2', paste0(sample_name, 'merged.vcf.gz'))
strelka_merged_annotated <- file.path(out_dir, 'strelka2', paste0(sample_name, 'merged_annotated.vcf.gz'))

purple_full(control_mame=control_mame,
            control=control,
            tumor_name=tumor_name,
            tumor=tumor,
            output_dir_cobalt=output_dir_cobalt,
            threads=threads,
            output_dir_amber=output_dir_amber,
            refgen=refgen,
            strelka_snvs=strelka_snvs,
            strelka_indels,
            strelka_merged,
            strelka_merged_annotated,
            output_dir_purple=output_dir_purple)