#' reheaderBam
#'
#' @description
#' Samtools R parser for reheader bams with the bam file name. 
#' Output file will have the same name as input BAM, so define a different output folder from the input folder. 
#'
#' @inheritParams reheaderBam
#' @examples
#' \dontrun{
#' reheaderBam(bam = 'raw/sample_tumor.bam',
#'                out_path = 'reheadered,
#'                samtools = 'bin/samtools')
#'}
#'
#' @export
reheaderBam <- function(bam,
                        out_path,
                        samtools = 'samtools'){
  #TODO delete input file option
  
  reheadered_bam <- file.path(out_path, basename(bam))
  
  # get bam id to change
  rg <- system(paste(samtools,
                     'view -H',
                     bam), intern = T)
  rg <- rg[grepl('@RG\tID', rg)]
  rg <- unlist(strsplit(rg, "\t"))
  sm <- rg[grepl('SM:', rg)]
  #id <- rg[grepl('ID:', rg)]
  #old_name  <- paste0(id, '\t', sm)
  
  old_name <- sm
  new_name <- gsub('\\..*$', '', basename(bam))
  #new_name <- paste0('ID:', new_name, '\t', 'SM:',  new_name)
  new_name <- paste0('SM:',  new_name)
  
  message(paste(Sys.time(),"\n",
                'Starting reheader tool using:\n',
                '>BAM file:', bam, '\n',
                '>Output path:', out_path, '\n'))
  
  system(paste0(samtools,
                ' view -h ',
                bam,
                ' | sed "s/', old_name, '/', new_name, '/" | ',
                samtools,
                ' view -Sb - > ', reheadered_bam))
  
  message(paste(Sys.time(),"\n", 'Finished', bam, '\n'))
  
}