devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

outPath <- '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/facets'

bams <- c('/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-21_BL.bam',
          '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-25_BL.bam',
          '/home/labs/lplab/msubirana/media/drive1/insulinomas/processed/hg38/bam/bwa/NET-29_BL.bam')

threads <- 4

for(bam in bams){

  normal <- bam
  tumor <- gsub("_BL","_TI",bam)
  outName <- gsub("_BL.bam","",basename(bam))
  system(paste('Rscript-3.5.1-bioc-3.8 /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/facets.R',
               normal,
               tumor,
               outName,
               outPath))

}
