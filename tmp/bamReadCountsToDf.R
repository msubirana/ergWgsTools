devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
path_bam <- getwd()
bams <- list.files(path_bam,
                   pattern = '\\.bam$',
                   full.names = T)

ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'

dfPos <- t(data.frame(c('chr14', '100277470', '100277470')))
rownames(dfPos) <- seq(1:nrow(dfPos))
colnames(dfPos) <- c('chr','start','end')

counts <- bamReadCountsToDf(bam = bam,
                                dfPos = dfPos,
                                ref = ref)

counts <- data.frame()

for(bam in bams){

  tmp_counts <- bamReadCountsToDf(bam = bam,
                    dfPos = dfPos,
                    ref = ref)

  counts <- rbind(counts, tmp_counts)
}


