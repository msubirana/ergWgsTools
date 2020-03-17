#' variantAnnotation
#'
#' @description
#' Raw VCF files are annotated using Variant Effect Predictor (\href{https://www.ensembl.org/info/docs/tools/vep/index.html}{VEP})
#' The VEP uses the coordinates and alleles in the VCF file to infer biological context for each variant including the location
#' of each mutation, its biological consequence (frameshift/ silent mutation), and the affected genes.
#' The following databases are used for VCF annotation:
#'
#' \itemize{
#'   \item \href{https://www.ensembl.org/index.html}{Ensembl database}: Protein-coding and non-coding genes, splice variants,
#'   cDNA and protein sequences, non-coding RNAs, among others annotations.
#'   \item {https://www.gencodegenes.org/}{GENCODE}: human and mouse high accuracy based on biological evidence annotations.
#'   \item {https://www.ncbi.nlm.nih.gov/refseq/}{RefSeq}: A comprehensive, integrated, non-redundant,
#'   well-annotated set of reference sequences including genomic, transcript, and protein.
#'   \item {http://genetics.bwh.harvard.edu/pph2/}{PolyPhen}: Polymorphism Phenotyping v2 is a tool which predicts possible impact of an amino acid substitution
#'   on the structure and function of a human protein using straightforward physical and comparative considerations.
#'   \item {https://sift.bii.a-star.edu.sg/}{SIFT}:	SIFT predicts whether an amino acid substitution affects protein function
#'   based on sequence homology and the physical properties of amino acids. SIFT can be applied to naturally occurring
#'   nonsynonymous polymorphisms and laboratory-induced missense mutations.
#'   \item {https://www.ncbi.nlm.nih.gov/snp/}{dbSNP}: dbSNP contains human single nucleotide variations, microsatellites,
#'   and small-scale insertions and deletions along with publication, population frequency, molecular consequence,
#'   and genomic and RefSeq mapping information for both common variations and clinical mutations.
#'   \item {https://cancer.sanger.ac.uk/cosmic}{COSMIC}: the Catalogue Of Somatic Mutations In Cancer, is the world's largest
#'   and most comprehensive resource for exploring the impact of somatic mutations in human cancer.
#'   \item {http://www.hgmd.cf.ac.uk/ac/index.php}{HGMD-PUBLIC}: The Human Gene Mutation Database (HGMD®) represents an attempt to
#'   collate all known (published) gene lesions responsible for human inherited disease,
#'   \item {https://www.ncbi.nlm.nih.gov/clinvar/}{ClinVar}: reports of the relationships among human variations and phenotypes,
#'   with supporting evidence.
#'   \item \href{https://www.internationalgenome.org/home}{1000 Genomes}: database with most genetic variants with frequencies of
#'   at least 1% in the populations studied.
#'   \item NHLBI-ESP
#'   \item \href{https://gnomad.broadinstitute.org/}{gnomAD}: The Genome Aggregation Database (gnomAD) is a resource developed by
#'   an international coalition of investigators,with the goal of aggregating and harmonizing both exome and genome sequencing
#'   data from a wide variety of large-scale sequencing projects, and making summary data available for the wider scientific community.
#'}
#'
#' @inheritParams somaticWgsAnalysis
#' @param vcf File
#' @param vep File
#' @param cache_file Nan
#' @examples
#' \dontrun{
#'
#'}
#'
#' @export
variantAnnotation <- function(vcf,
                        vep,
                        cache_dir,
                        ref,
                        out_path,
                        sample_name){
  # define output


  message(paste(Sys.time(),"\n",
                'Starting VEP annotation using:\n',
                '>Vcf file:', vcf, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_muse, '\n',
                '>Genome aggregation database:', af_only_gnomad))


  vcf <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/calling_ergWgsTools/strelka2/NET-10_out_strelka2/results/variants/NET-10_out_strelka2_snvs_postCalling.vcf'
  out_path <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/vcf/vep_annotation'
  cache_dir <- '/imppc/labs/lplab/share/marc/refgen/hg38'
  sample_name <- gsub(".vcf", "", basename(vcf))
  annotated_vcf <- file.path(out_path, paste0(sample_name, '_vep_annotated.vcf'))
  perl <- 'perl'
  vcf_maf <- '/imppc/labs/lplab/share/marc/repos/vcf2maf/vcf2maf.pl'
  vep_path <- '/imppc/labs/lplab/share/marc/repos/ensembl-vep'
  tumor_id <- 'NET-10_TI_muse'
  normal_id <- 'NET-10_BL_muse'
  vcf_tumor_id <- 'TUMOR'
  vcf_normal_id <- 'NORMAL'
  maf <- gsub('\\..*$', '.maf', vcf)
  ref <- '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa'
  bcftools <- 'bcftools'

  #
  # filter chr from vcf
  regions_chr <- paste(paste0('chr', seq_len(22), collapse = ","), 'chrY', 'chrX', collapse = ",")

  # vcf <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/vcf/mutec2/NET-10_mutec2.vcf'
  # vcf <- '/imppc/labs/lplab/share/marc/repos/ergWgsTools/proves/processed/vcf/pindel/NET-10_somatic.vcf'
  # system(paste('bgzip -c', vcf, '>', paste0(vcf, '.gz') ))
  # system(paste('tabix', paste0(vcf, '.gz')))
  #
  # vcf_filtered <- paste0(gsub("\\..*$", "", vcf), "_filtered.vcf")
  #
  # system(paste(bcftools, 'view',
  #              paste0(vcf, '.gz'),
  #              '--regions', regions_chr,
  #              '>', vcf_filtered))

  system(paste(perl, vcf_maf,
               '--input', vcf,
               '--output-maf', maf,
               '--tumor-id', tumor_id,
               '--normal-id', normal_id,
               '--ref-fasta', ref,
               '--vcf-tumor-id', vcf_tumor_id,
               '--vcf-normal-id', vcf_normal_id,
               '--vep-path', vep_path,
               '--vep-data', cache_dir,
               '--filter-vcf', 0,
               '--ncbi-build GRCh38'))





  # system(paste(vep,
  #              '-i', vcf,
  #              '--cache',
  #              '--dir', cache_dir,
  #              '--format vcf',
  #              '--vcf',
  #              '-o', annotated_vcf))
  #


}

library(maftools)

maf_file <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/vcf/calling_ergWgsTools/strelka2/NET-10_out_strelka2/results/variants/NET-10_out_strelka2_snvs_postCalling.maf'
maftools::read.maf(maf_file)
