#' mantaCalling
#'
#' @description
#' Tumor-normal pair somatic variant calling using manta.
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' mantaCalling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                threads = 2,
#'                manta = '/bin/manta-1.4.0')
#'}
#'
#' @export
mantaCalling <- function(tumor_file,
                         normal_file,
                         sample_name,
                         ref,
                         out_path,
                         manta,
                         threads){
  # define output
  out_path <- file.path(out_path, "manta")
  dir.create(out_path, showWarnings = F)

  out_manta <- file.path(out_path, paste0(sample_name, "_out_manta"))
  conf_manta <- file.path(manta, 'bin/configManta.py')

  system(paste(conf_manta,
               "--normalBam", normal_file,
               "--tumorBam", tumor_file,
               "--referenceFasta", ref,
               "--runDir", out_manta))

  # execution of job in the defined cores
  run_manta <- file.path(out_manta, 'runWorkflow.py')

  cores <- as.numeric(threads) / 2

  system(paste(run_manta,
               "-m local",
               "-j", cores))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}

#' strelka2Calling
#'
#' @description
#' Tumor-normal pair somatic variant calling using strelka2
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' strelka2Calling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                threads = 2,
#'                indel_candidates = 'manta/results/variants/candidateSmallIndels.vcf.gz',
#'                strelka2 = '/bin/strelka-2.9.3')
#'}
#'
#' @export
strelka2Calling <- function(tumor_file,
                            normal_file,
                            sample_name,
                            ref,
                            out_path,
                            threads,
                            indel_candidates,
                            strelka2,
                            bcftools){
  # define output
  out_path <- file.path(out_path, "strelka2")
  dir.create(out_path, showWarnings = F)

  out_strelka2 <- file.path(out_path, paste0(sample_name, "_out_strelka2"))
  conf_strelka2 <- file.path(strelka2, 'bin/configureStrelkaSomaticWorkflow.py')

  out_manta <- file.path(out_path, paste0(sample_name, "_out_manta"))

  message(paste(Sys.time(),"\n",
                'Starting Strelka2 calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_strelka2, '\n',
                '>Number of threads:', threads, '\n',
                '>INDEL candidates:', indel_candidates))

  system(paste(conf_strelka2,
               "--normalBam", normal_file,
               "--tumorBam", tumor_file,
               "--referenceFasta", ref,
               "--runDir", out_strelka2,
               '--indelCandidates', indel_candidates))

  # execution of job in the defined cores
  run_strelka2 <- file.path(out_strelka2, 'runWorkflow.py')

  cores <- as.numeric(threads) / 2

  system(paste(run_strelka2,
               "-m local",
               "-j", cores))


  vcfs_strelka_path <- file.path(out_strelka2, 'results', 'variants')

  vcfs_strelka <- list.files(vcfs_strelka_path,
                             pattern = "*.vcf.gz$",
                             full.names = T)


  lapply(vcfs_strelka, function(x) system(paste('gunzip -k', x)))

  vcfs_strelka <- list.files(vcfs_strelka_path,
                             pattern = "*.vcf$",
                             full.names = T)

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}
