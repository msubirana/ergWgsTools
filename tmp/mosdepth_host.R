devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

output_path <- '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/coverage'

bams <- c('/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-21_BL.bam',
          '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-21_TI.bam',
          '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-25_BL.bam',
          '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-25_TI.bam',
          '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-29_BL.bam',
          '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-29_TI.bam')

threads <- 4

for(bam in bams){

  system(paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/mosdepth.R',
                 bam,
                 output_path,
                 threads))

}
