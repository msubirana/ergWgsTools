#' bamReadCountsToDf
#'
#' Count allelic frequency for a set of positions
#'
#' @param bam Path of bam
#' @param dfPos Dataframe of counting positions (format chr start end) in 1 base format.
#' Examples:
#' # 1-start, fully-closed (1-based) "chr14:100277470-100277470" -> chr14 100277470 100277470
# 0-start, half-open (0-based) BED "chr14\t100277469\t100277470" -> chr14 100277470 100277470
#' @param ref Reference genome to use


library(R.utils)

bamReadCountsToDf <- function(bam,
                              dfPos,
                              ref){

  posFile <- file.path(dirname(bam), "tmpPos.tsv")

  write.table(dfPos, posFile, sep = "\t", col.names = F, row.names = F, quote=FALSE)

  rawCount <- system(paste('bam-readcount -f', ref,
                           bam,
                           '-l', posFile), intern = T)


  sample <- basename(gsub("\\..*", "", bam))

  dfAlleleCounts <- data.frame()

  for (count in rawCount){

    splitCount <- unlist(strsplit(count, "\t"))

    subCount <- splitCount[6:9]

    alleleCount <- lapply(subCount, function(x) unlist(strsplit(x, ":"))[1:2])

    dfAlleleCount <- data.frame(alleleCount, stringsAsFactors = F)

    colnames(dfAlleleCount) <- dfAlleleCount[1,]

    dfAlleleCount <- dfAlleleCount[-1,]

    rownames(dfAlleleCount) <- seq(1, nrow(dfAlleleCount))

    dfAlleleCount$sample <- sample

    dfAlleleCount$chr <- splitCount[1]

    dfAlleleCount$start <- splitCount[2]

    dfAlleleCount <- dfAlleleCount[c(5,6,7,1,2,3,4)]

    dfAlleleCounts <- rbind(dfAlleleCounts, dfAlleleCount)

  }

  return(dfAlleleCounts)

}
