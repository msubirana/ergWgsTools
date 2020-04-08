samtools <- 'samtools'
threads <- 4
bam_path <- getwd()
output_path <- '/media/msubirana/plab1/resorted'

bams <- list.files(bam_path,
           pattern = '\\.bam$')

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

