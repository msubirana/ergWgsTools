#' facets
#'
#' @description
#' This function carries out allele-specific copy number and clonal heterogeneity analysis tool for high-throughput DNA sequencing
#'
#' @param normal Normal bam file
#' @param tumor Tumour bam file
#' @param outName Name for the output file for the paired tumor normal analysis
#' @param outPath Path where the output of the analysis will be saved.
#'
#' @examples
#' \dontrun{
#' normal <- 'raw/sample12_norm.bam'
#' tumor <- 'raw/sample12_tum.bam'
#' outName <- 'sample12'
#' outPath <- 'rst/facets'
#'
#' facets(inputFile, threads, outPath)
#' }
#'
#' @export

facets <- function(normal,
                   tumor,
                   outName,
                   outPath){

  # snp pileup
  vcf <- '/imppc/labs/lplab/share/marc/refgen/hg38/00-common_all.vcf.gz'
  output <- file.path(outPath, outName)

  message(paste(Sys.time(),"\n",
                'Starting facets using:\n',
                normal, 'as a normal bam\n',
                tumor, 'as a tumor bam\n',
                outName, 'as a out name\n',
                outPath, 'as output path\n'))

  system(paste("snp-pileup",
               vcf,
               paste0(output,".csv"),
               normal,
               tumor))

  # facets analysis

  #Maintain the randomization
  set.seed(1234)

  # read the data
  rcmat = readSnpMatrix(paste0(output,".csv"))
  # fit segmentation tree
  xx = preProcSample(rcmat)
  # estimate allele specific copy numbers. The small cval is, the more sensitive for small changes
  oo = procSample(xx,cval=150)
  # EM fit version 1
  fit = emcncf(oo)

  # segmentation result and EM fit
  write.table(fit$cncf, file=paste0(output,"_comp_cncf.tsv"), sep="\t", row.names = FALSE)

  # purity and ploidy
  basic <- data.frame(fit$loglik, fit$purity, fit$ploidy, fit$dipLogR)
  colnames(basic) <- c("Log_likelihood", "Purity", "Ploidy", "Estimated_logR_diploid_segments")
  write.table(basic, file=paste0(output,"_comp_basic.tsv"), sep="\t", row.names = FALSE)

  #plot
  png(paste0(output,"_comp.png"), width = 900, height = 900, units = "px", pointsize = 18)
  plotSample(oo, emfit = fit)
  dev.off()

  message(paste(Sys.time(),"\n",
                'Finished facets using:\n',
                normal, 'as a normal bam\n',
                tumor, 'as a tumor bam\n',
                outName, 'as a out name\n',
                outPath, 'as output path\n'))
}

