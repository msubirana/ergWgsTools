threads <- parallel::detectCores()
devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
inputPath <- '/imppc/labs/lplab/share/marc/insulinomas/raw/fastq/'
inputFiles <- list.files(inputPath,
           pattern = '\\_R1.fq.gz$',
           full.names = T)

ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
outPathBam <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa'
rstPath <- '/imppc/labs/lplab/share/marc/insulinomas/rst'

for(inputFile in inputFiles){

  wgsSomaticPreprocessing(inputFile = inputFile,
                          ref = ref,
                          outPathBam = outPathBam,
                          threads = threads,
                          removeOpt = removeOpt,
                          rstPath = rstPath)

}
