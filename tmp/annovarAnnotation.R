source('/imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/variables.R')
library(devtools)
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
threads <- parallel::detectCores()

gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk'
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
bcftools <- 'bcftools'

args <- commandArgs(trailingOnly = TRUE)

vcf <- args[1]
out_vcf <- args[2]

annovarAnnotation(vcf = vcf,
                  out_vcf = out_vcf,
                  threads = threads)
