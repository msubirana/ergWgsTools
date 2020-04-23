devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
fastq_path <- getwd()
out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/realigned'

fastqs <- list.files(fastq_path,
                     pattern = "\\_R1.fq$",
                     full.names = T)
cores <- 28

for(fastq in fastqs){

  sample_name <- gsub("_.*", '', basename(fastq))
  name = paste0('bwa_', sample_name)
  queue = 'imppcv3'
  log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
  script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/bwaAlignment.R',
                 fastq,
                 out_path)

  email = 'clusterigtpmsubirana@gmail.com'

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)

}

####

bam_path <- '/media/msubirana/plab1/resorted'
out_path <- '/home/labs/lplab/msubirana/Desktop/icgc_downloads/realigned'
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'

bams <- list.files(bam_path,
           pattern = '\\.bam$',
           full.names = T)

for(bam in bams){

  bwaAlignment(input_file = bam,
               type_input_file = 'bam',
               ref = ref,
               out_path = out_path,
               threads = 2,
               gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
               sambamba = 'sambamba',
               bwa = 'bwa',
               samblaster = 'samblaster',
               samtools = 'samtools')

}

###
fq_path <- '/home/labs/lplab/msubirana/Desktop/icgc_downloads/keep'
out_path <- '/media/msubirana/plab1/hg38'
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'

fqs <- list.files(fq_path,
                   pattern = '\\_R1.fq$',
                   full.names = T)

for(fq in fqs){

  bwaAlignment(input_file = fq,
               type_input_file = 'fastq',
               ref = ref,
               out_path = out_path,
               threads = 2,
               gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
               sambamba = 'sambamba',
               bwa = 'bwa',
               samblaster = 'samblaster',
               samtools = 'samtools')

}

