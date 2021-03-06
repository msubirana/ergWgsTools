% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mutect2Calling.R
\name{mutect2Calling}
\alias{mutect2Calling}
\title{mutect2Calling}
\usage{
mutect2Calling(
  tumor_file,
  normal_file,
  sample_name,
  ref,
  out_path,
  gatk4,
  threads,
  af_only_gnomad,
  bcftools
)
}
\arguments{
\item{tumor_file}{Tumor bam to file to perform the variant calling.}

\item{normal_file}{Normal bam to file to perform the variant calling.}

\item{ref}{Path for the reference genome to use for the alignment (fasta format) and the corresponding indexes
generated with bwa index and a dictionary index file generated by  CreateSequenceDictionary gatk tool.}

\item{out_path}{Path where the output of the analysis will be saved.}

\item{gatk4}{Path of GATK4 binary.}

\item{threads}{Number of threads to use in the analysis.}

\item{af_only_gnomad}{Genome aggregation database used as a germline resource. Have to be base on the same reference genome
as `ref`. \href{https://gnomad.broadinstitute.org/downloads}{gnomAD}}
}
\description{
Tumor-normal pair somatic variant calling using MuTect2
}
\examples{
\dontrun{
mutect2Calling(tumor_file = 'raw/sample_tumor.bam',
               normal_file = 'raw/sample_normal.bam',
               sample_name = 'sample'
               ref = 'ref/hg38.fa',
               out_path = 'rst',
               gatk4 = 'bin/gatk-4.1.3.0/gatk',
               threads = 2,
               af_only_gnomad = 'hg38/af-only-gnomad.hg38.vcf.gz')
}

}
