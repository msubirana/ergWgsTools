#' annovarAnnotation
#'
#' @description
#' R parser for Annovar
#'
#' @param vcf Vcf file to annotate
#' @param threads Number of threads to use in the analysis.
#' @param out_vcf Path where to save the annotated vcf.
#' @param annovar Path to the annovar binary folder.
#' @param perl Path of perl executable.
#' @param humandb Path to the annovar huban database.
#' @examples
#' \dontrun{
#' annovarAnnotation(vcf = 'NET-11_out_strelka2_indels_postCalling.vcf',
#'                   out_vcf = 'NET-11_annotated.vcf',
#'                   threads = 2)
#' }
#'
#' @export
annovarAnnotation <- function(vcf,
                              out_vcf,
                              threads,
                              annovar='/imppc/labs/lplab/share/bin/annovar',
                              humandb='/imppc/labs/lplab/share/bin/annovar/humandb',
                              perl='perl'){


  corrected_vcf <- gsub("\\.vcf", "_corr.vcf", vcf)

  # correct vcf for annovar annotation

  system(paste('cat', vcf,
               '| grep -v "##"',
               '| awk \'{print $1"\t"$2"\t"$2"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11}\'',
               '>', corrected_vcf))

  # annovar annotation gene based only

  system(paste(perl, file.path(annovar, 'table_annovar.pl'),
               corrected_vcf,
               humandb,
               '-buildver hg38',
               '-out', out_vcf,
               '-remove',
               '-nastring NA',
               '-thread', threads,
               '-protocol',
               'refGene',
               '-operation g'))

  # annovar annotation with filter or region based

  # system(paste(perl, file.path(annovar, 'table_annovar.pl'),
  #              corrected_vcf,
  #              humandb,
  #              '-buildver hg38',
  #              '-out', out_vcf,
  #              '-remove',
  #              '-nastring NA',
  #              '-thread', threads,
  #              '-protocol',
  #              'refGene,cytoBand,exac03,avsnp150,dbnsfp33a',
  #              '-operation g,r,f,f,f'))

  unlink(corrected_vcf)

  }
