samtools <- 'samtools'
threads <- 4
output_path <- '/media/msubirana/IGTP20228/insulinomas/processed/hg38/bam/bwa/icgc_downloads/resorted'
bam_path <- '.'
bams <- list.files(bam_path,
           pattern = '\\.bam$',
           full.names = T)


for(bam in bams){

  index <- paste0(bam, '.bai')

  if(!file.exists(index)){

    system(paste(samtools,
                 'index',
                 '-@', threads,
                 bam))
  }

  sorted_bam <- file.path(output_path, basename(bam))

  system(paste(samtools,
               'sort',
               '-@', threads,
               bam,
               '-O BAM -o', sorted_bam,
               ';', samtools,
               'index',
               '-@', threads,
               sorted_bam))
}

