#' variantCalling
#'
#' @description
#' Aligned and co-cleaned BAM files are processed as tumor-normal pairs.
#' Variant calling is performed using six separate pipelines:
#'
#' \itemize{
#'   \item \href{https://bioinformatics.mdanderson.org/public-software/muse/}{MuSE}
#'   \item \href{https://gatk.broadinstitute.org/hc/en-us/articles/360035531132--How-to-Call-somatic-mutations-using-GATK4-Mutect2}{MuTect2}
#'   \item \href{http://varscan.sourceforge.net/}{VarScan2}
#'   \item \href{https://github.com/genome/somatic-sniper}{SomaticSniper}
#'   \item \href{http://gmt.genome.wustl.edu/packages/pindel/}{Pindel}
#'   \item \href{https://github.com/Illumina/strelka}{Strelka2}
#'   \item \href{https://github.com/Illumina/manta}{Manta}
#'   }
#'
#' @inheritParams somaticWgsAnalysis
#' @examples
#' \dontrun{
#' variantCalling(tumor_file = 'NET-10_TI_mkdup_sub_0005.bam',
#'                normal_file = 'NET-10_BL_mkdup_sub_0005.bam',
#'                sample_name = 'NET-10',
#'                ref = 'hg38.fa',
#'                out_path = 'processed/vcf',
#'                threads = 2)
#'}
#' @export


#'
variantCalling <- function(tumor_file,
                           normal_file,
                           sample_name,
                           ref = '/imppc/labs/lplab/share/marc/refgen/hg38/hg38.fa',
                           out_path,
                           threads = 1,
                           gatk4 = '/imppc/labs/lplab/share/bin/gatk-4.1.3.0/gatk',
                           muse = '/imppc/labs/lplab/share/marc/repos/MuSE/MuSE',
                           bwa = 'bwa',
                           samblaster = 'samblaster',
                           sambamba = 'sambamba',
                           samtools = 'samtools',
                           somatic_sniper = '/imppc/labs/lplab/share/marc/repos/somatic-sniper/build/bin/bam-somaticsniper',
                           varscan2 = '/imppc/labs/lplab/share/marc/repos/varscan/VarScan.v2.4.4.jar',
                           manta = '/software/debian-8/bio/manta-1.4.0',
                           strelka2 = '/soft/bio/strelka-2.9.3',
                           af_only_gnomad = '/imppc/labs/lplab/share/marc/refgen/hg38/af-only-gnomad.hg38.vcf.gz',
                           pindel = '/soft/bio/pindel/pindel',
                           centromeres_telomeres = '/imppc/labs/lplab/share/marc/refgen/hg38/centromeres.bed',
                           perl = 'perl',
                           python_radia = '/imppc/labs/lplab/share/marc/repos/miniconda/bin/python2.7',
                           radia_path = '/imppc/labs/lplab/share/marc/repos/radia/scripts',
                           bcftools = 'bcftools',
                           tumor_vcf_id = 'TUMOR',
                           fpfilter = '/imppc/labs/lplab/share/marc/repos/fpfilter-tool/fpfilter.pl',
                           bam_readcount = 'bam-readcount'){

  # check BAM indexes
  sambambaIndex(bam = tumor_file,
                threads = threads)

  sambambaIndex(bam = normal_file,
                threads = threads)

  # MuSE calling
  museCalling(tumor_file = tumor_file,
              normal_file = normal_file,
              sample_name = sample_name,
              ref = ref,
              out_path = out_path,
              muse = muse,
              af_only_gnomad = af_only_gnomad,
              bcftools = bcftools)


  # VarScan2 calling
  varscan2Calling(tumor_file = tumor_file,
                  normal_file = normal_file,
                  sample_name = sample_name,
                  ref = ref,
                  out_path = out_path,
                  varscan2 = varscan2,
                  samtools = samtools,
                  fpfilter = fpfilter,
                  perl = perl,
                  bcftools = bcftools)

  # Pindel calling
  pindelCalling(tumor_file = tumor_file,
                normal_file = normal_file,
                sample_name = sample_name,
                ref = ref,
                out_path = out_path,
                pindel = pindel,
                sambamba = sambamba,
                samtools = samtools,
                threads = threads,
                perl = perl,
                gatk4 = gatk4,
                centromeres_telomeres = centromeres_telomeres,
                bcftools = bcftools)

  # manta calling
  mantaCalling(tumor_file = tumor_file,
               normal_file = normal_file,
               sample_name = sample_name,
               ref = ref,
               out_path = out_path,
               manta = manta,
               threads = threads)

  # Strelka2 calling
  strelka2Calling(tumor_file = tumor_file,
                  normal_file = normal_file,
                  sample_name = sample_name,
                  ref = ref,
                  out_path = out_path,
                  threads = threads,
                  indel_candidates = file.path(out_path, 'manta', paste0(sample_name, "_out_manta"),
                                               'results/variants/candidateSmallIndels.vcf.gz'),
                  strelka2 = strelka2,
                  bcftools = bcftools)


  # MuTect2 calling
  mutect2Calling(tumor_file = tumor_file,
                 normal_file = normal_file,
                 sample_name = sample_name,
                 ref = ref,
                 out_path = out_path,
                 gatk4 = gatk4,
                 threads = threads,
                 af_only_gnomad = af_only_gnomad,
                 bcftools = bcftools)

  # RADIA calling
  radiaCalling(tumor_file = tumor_file,
               normal_file = normal_file,
               sample_name = sample_name,
               ref = ref,
               out_path = out_path,
               radia_path = radia_path,
               python_radia = python_radia,
               samtools = samtools,
               threads = threads,
               bcftools = bcftools)

  # Somatic Sniper calling
  somaticsniperCalling(tumor_file = tumor_file,
                       normal_file = normal_file,
                       sample_name = sample_name,
                       ref = ref,
                       out_path = out_path,
                       somatic_sniper = somatic_sniper,
                       fpfilter = fpfilter,
                       perl = perl,
                       bcftools = bcftools)

}


#' museCalling
#'
#' @description
#' Tumor-normal pair somatic variant calling using MuSE
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' museCalling(tumor_file = 'raw/sample_tumor.bam',
#'             normal_file = 'raw/sample_normal.bam',
#'             sample_name = 'sample'
#'             ref = 'ref/hg38.fa',
#'             out_path = 'rst',
#'             muse = '/bin/MuSE',
#'             af_only_gnomad = 'hg38/af-only-gnomad.hg38.vcf.gz')
#' }
#'
#' @export
museCalling <- function(tumor_file,
                        normal_file,
                        sample_name,
                        ref,
                        out_path,
                        muse,
                        af_only_gnomad,
                        bcftools){
  # define output
  out_path <- file.path(out_path, "muse")
  dir.create(out_path, showWarnings = F)

  out_muse <- file.path(out_path, paste0(sample_name, "_muse"))
  intermediate_muse_call <- file.path(out_path, paste0(sample_name))

  message(paste(Sys.time(),"\n",
                'Starting MuSE calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_muse, '\n',
                '>Genome aggregation database:', af_only_gnomad))

  # generate intermediate muse call

  system(paste(muse, 'call',
               '-f', ref,
               tumor_file,
               normal_file,
               '-O', intermediate_muse_call))

  intermediate_muse_call <- file.path(out_path, paste0(sample_name, ".MuSE.txt"))

  # muse calling
  system(paste(muse, 'sump',
               '-I', intermediate_muse_call,
               '-G',
               '-D', af_only_gnomad,
               '-O', paste0(out_muse, '.vcf')))


  unlink(intermediate_muse_call)

  # PASS variants filtering
  system(paste(bcftools, 'view',
               '-f PASS', paste0(out_muse, '.vcf'),
               '>', paste0(out_muse, '_PASS.vcf')))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}

#' mutect2Calling
#'
#' @description
#' Tumor-normal pair somatic variant calling using MuTect2
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' mutect2Calling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                gatk4 = 'bin/gatk-4.1.3.0/gatk',
#'                threads = 2,
#'                af_only_gnomad = 'hg38/af-only-gnomad.hg38.vcf.gz')
#'}
#'
#' @export
mutect2Calling <- function(tumor_file,
                           normal_file,
                           sample_name,
                           ref,
                           out_path,
                           gatk4,
                           threads,
                           af_only_gnomad,
                           bcftools){
  # define output
  out_path <- file.path(out_path, "mutect2")
  dir.create(out_path, showWarnings = F)

  out_mutect2 <- file.path(out_path, paste0(sample_name, "_mutect2"))

  message(paste(Sys.time(),"\n",
                'Starting MuTect2 calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_mutect2, '\n',
                '>Number of threads:', threads, '\n',
                '>Genome aggregation database:', af_only_gnomad))

  # MuTect2 calling
  system(paste(gatk4,
               '--java-options', paste0('-XX:ParallelGCThreads=',threads),
               'Mutect2',
               '-R', ref,
               '-I', tumor_file,
               '-I', normal_file,
               '-O', paste0(out_mutect2, '.vcf'),
               '-germline-resource', af_only_gnomad))

  # PASS variants filtering

  system(paste(gatk4, 'FilterMutectCalls',
               '--java-options', paste0('-XX:ParallelGCThreads=',threads),
               '-V', paste0(out_mutect2, '.vcf'),
               '-R', ref,
               '-O', paste0(out_mutect2, '_tmp.vcf')))

  # PASS variants filtering
  system(paste(bcftools, 'view',
               '-f PASS', paste0(out_mutect2, '_tmp.vcf'),
               '>', paste0(out_mutect2, '_PASS.vcf')))


  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))
}

#' somaticsniperCalling
#'
#' @description
#' Tumor-normal pair somatic variant calling using SomaticSniper
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' somaticsniperCalling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                somatic_sniper = '/bin/bam-somaticsniper')
#'}
#'
#' @export
somaticsniperCalling <- function(tumor_file,
                                 normal_file,
                                 sample_name,
                                 ref,
                                 out_path,
                                 somatic_sniper,
                                 fpfilter,
                                 perl,
                                 bcftools){
  # define output
  out_path <- file.path(out_path, "somaticsniper")
  dir.create(out_path, showWarnings = F)

  out_somaticsniper <- file.path(out_path, paste0(sample_name, "_somaticsniper.vcf"))


  message(paste(Sys.time(),"\n",
                'Starting SomaticSniper calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_somaticsniper, '\n',
                '>Number of threads:', threads, '\n'))

  # SomaticSniper calling
  system(paste(somatic_sniper,
               '-f', ref,
               tumor_file,
               normal_file,
               out_somaticsniper,
               '-q 1',
               '-L',
               '-G',
               '-Q 15',
               '-s 0.01',
               '-T 0.85',
               '-N 2',
               '-r 0.001',
               '-F vcf'))

  sample_name <- gsub(".vcf", "", basename(out_somaticsniper))

  fpfilterTool(vcf = out_somaticsniper,
               tumor_file = tumor_file,
               sample_name = sample_name,
               ref = ref,
               fpfilter = fpfilter,
               perl = perl,
               out_path = out_path,
               bam_readcount = bam_readcount)

  out_fpfilter <- file.path(out_path, "fpfilter")
  vcf_filtered <- file.path(out_fpfilter, paste0(sample_name, ".vcf"))

  # PASS variants filtering
  system(paste(bcftools, 'view',
               '-f PASS', vcf_filtered,
               '>', paste0(file.path(out_fpfilter, paste0(sample_name, '_PASS.vcf')))))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))
}

#' varscan2Calling
#'
#' @description
#' Tumor-normal pair somatic variant calling using VarScan2.
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' varscan2Calling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                varscan2 = '/bin/VarScan.v2.4.4.jar',
#'                threads = 2,
#'                samtools = '/bin/samtools')
#'}
#'
#' @export
varscan2Calling <- function(tumor_file,
                            normal_file,
                            sample_name,
                            ref,
                            out_path,
                            varscan2,
                            samtools,
                            fpfilter,
                            perl,
                            bcftools){
  # define output
  out_path <- file.path(out_path, "varscan2")
  dir.create(out_path, showWarnings = F)

  intermediate_mpileup <- file.path(out_path, paste0(sample_name, '_intermediate_mpileup.pileup'))
  out_varscan2 <- file.path(out_path, paste0(sample_name, "_out_varscan2"))

  message(paste(Sys.time(),"\n",
                'Starting VarScan2 calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_varscan2, '\n'))

  # mpileup
  system(paste(samtools, 'mpileup',
               '-f', ref,
               '-q 1',
               '-B',
               tumor_file,
               normal_file,
               ">", intermediate_mpileup))

  # VarScan2 calling
  system(paste('java -jar', varscan2,
               'somatic',
               intermediate_mpileup,
               out_varscan2,
               '--mpileup 1',
               '--min-coverage 8',
               '--min-coverage-normal 8',
               '--min-coverage-tumor 6',
               '--min-var-freq 0.10',
               '--min-freq-for-hom 0.75',
               '--normal-purity 1.0',
               '--tumor-purity 1.00',
               '--p-value 0.99',
               '--somatic-p-value 0.05',
               '--strand-filter 0',
               '--output-vcf'))

  unlink(intermediate_mpileup)

  # fpfilter
  for(vcf in paste0(out_varscan2, c(".indel.vcf", ".snp.vcf"))){

    sample_name <- gsub(".vcf", "", basename(vcf))

    fpfilterTool(vcf = vcf,
                 tumor_file = tumor_file,
                 sample_name = sample_name,
                 ref = ref,
                 fpfilter = fpfilter,
                 perl = perl,
                 out_path = out_path,
                 bam_readcount = bam_readcount)

    out_fpfilter <- file.path(out_path, "fpfilter")
    vcf_filtered <- file.path(out_fpfilter, sample_name, ".vcf")

    # PASS variants filtering
    system(paste(bcftools, 'view',
                 '-f PASS', vcf_filtered,
                 '>', paste0(file.path(out_fpfilter, paste0(sample_name, '_PASS.vcf')))))

  }


  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))
}

#' pindelCalling
#'
#' @description
#' Tumor-normal pair somatic variant calling using Pindel
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' pindelCalling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst')
#'}
#'
#' @export
pindelCalling <- function(tumor_file,
                          normal_file,
                          sample_name,
                          ref,
                          out_path,
                          pindel,
                          sambamba,
                          samtools,
                          threads,
                          perl,
                          gatk4,
                          centromeres_telomeres,
                          bcftools){
  # define output
  out_path <- file.path(out_path, "pindel")
  dir.create(out_path, showWarnings = F)

  out_pindel <- file.path(out_path, paste0(sample_name, "_out_pindel"))

  normal_file_filtered <- file.path(out_path, basename(normal_file))
  pindel2vcf4tcga <- file.path(dirname(pindel), 'pindel2vcf4tcga')
  somatic_indelfilter <- file.path(dirname(pindel), 'somatic_filter', 'somatic_indelfilter.pl')

  message(paste(Sys.time(),"\n",
                'Starting Pindel calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_pindel, '\n',
                '>Number of threads:', threads, '\n'))

  # create conf file
  ti_is <- insertSizePindel(out_path = out_path,
                            bam_file = normal_file,
                            sambamba = sambamba,
                            samtools = samtools)

  nr_is <- insertSizePindel(out_path = out_path,
                            bam_file = tumor_file,
                            sambamba = sambamba,
                            samtools = samtools)

  config_file <- file.path(out_path, 'config_file')
  writeLines(c(ti_is, nr_is), config_file)

  # Pindel calling
  system(paste(pindel,
               '-f', ref,
               '-i', config_file,
               '-o', out_pindel,
               '--exclude', centromeres_telomeres,
               '-T', threads))

  unlink(file.path(out_path, basename(normal_file)))
  unlink(file.path(out_path, basename(tumor_file)))
  unlink(file.path(out_path, paste0(basename(normal_file), ".bai")))
  unlink(file.path(out_path, paste0(basename(tumor_file), ".bai")))

  # Pindel output to vcf
  # merge deletions(D) and short insertions (SI)

  pindel_files <- list.files(out_path,
                             full.names = T)

  pindel_files <- c(pindel_files[grep("_SI", pindel_files)],
                    pindel_files[grep("_D", pindel_files)])

  merged_pindel <- file.path(out_path, paste0(sample_name, '_merged'))


  for(pindel_file in pindel_files){

    system(paste('grep ChrID', pindel_file, '>>', merged_pindel))
  }

  # somatic filter
  somatic_indel_filter_config <- file.path(out_path, 'somatic.indel.filter.config')
  somatic_output <- file.path(out_path, paste0(sample_name, '_somatic.vcf'))

  somatic_config <- paste0('indel.filter.input = ', merged_pindel, '\n',
                           'indel.filter.vaf = 0.08', '\n',
                           'indel.filter.cov = 20', '\n',
                           'indel.filter.hom = 6', '\n',
                           'indel.filter.pindel2vcf = ', pindel2vcf4tcga, '\n',
                           'indel.filter.reference = ',  ref, '\n',
                           'indel.filter.referencename = ', gsub("\\..*$", "", basename(ref)), '\n',
                           'indel.filter.referencedate = ', Sys.time(), '\n',
                           'indel.filter.output = ', somatic_output)

  writeLines(somatic_config, somatic_indel_filter_config)

  # apply somatic filter and convert output to vcf
  system(paste(perl, somatic_indelfilter, somatic_indel_filter_config))

  # # sort vcf
  # sorted_vcf <- paste0(gsub('\\..*$', '',somatic_output), '_sorted.vcf')
  # system(paste(gatk4,
  #              'SortVcf',
  #              '--CREATE_INDEX=true',
  #              '--SEQUENCE_DICTIONARY', gsub(".fa", ".dict", ref),
  #              '-I', somatic_output,
  #              '-O', sorted_vcf))

  # vcf_old_names <- system(paste(bcftools,
  #                               'query -l', sorted_vcf), intern = T)
  #
  # vcf_new_names <- c('NORMAL', 'TUMOR')
  #
  # new_header_file <- file.path(out_path, paste0(sample_name, '.header'))
  #
  # new_header_vcf <- paste(c(vcf_old_names[1], " ",
  #                           vcf_new_names[1], '\n',
  #                           vcf_old_names[2], " ",
  #                           vcf_new_names[2]),
  #                         collapse = "")
  #
  # writeLines(new_header_vcf, new_header_file)
  #
  #
  # reheadered_vcf <- file.path(out_path, paste0(sample_name, '_reheader.vcf'))
  #
  #
  # system(paste(bcftools,
  #              'reheader',
  #              '-s', new_header_file,
  #              '-o',reheadered_vcf,
  #              sorted_vcf))

  # PASS variants filtering
  system(paste(bcftools, 'view',
               '-f PASS', somatic_output,
               '>', paste0(out_pindel, '_PASS.vcf')))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))
}


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

  # PASS variants filtering
  for(vcf in vcfs_strelka){

    vcf_out <- file.path(dirname(vcf),
                         paste0(sample_name,
                                gsub('somatic.', '_out_strelka2_',
                                     gsub(".vcf", "_PASS.vcf",
                                          basename(vcf)))))

    system(paste(bcftools, 'view',
                 '-f PASS', vcf,
                 '>', vcf_out))

  }

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}


#' insertSizePindel
#'
#' @description
#' Calculates the mean insert size and returns the name of a bam-file,
#' the expected average insert size, and a label to indicate the identity of the sample.
#'
#' @inheritParams variantCalling
#' @param size_subsample Number of reads in the BAM file used for the insert size calculation.
#' @param bam_file BAM file where to calculate the insert size.
#' @examples
#' \dontrun{
#' insertSizePindel(bam_file = 'raw/sample_tumor.bam',
#'                samtools = '/bin/samtools',
#'                sambamba = '/bin/sambamba')
#'}
#'
#' @export
insertSizePindel <- function(out_path,
                             sambamba,
                             samtools,
                             bam_file,
                             size_subsample = 1000000){

  out_bam <- file.path(out_path, basename(bam_file))

  # filter reads
  system(paste(sambamba, 'view', bam_file,
               '--filter "not (unmapped or duplicate or secondary_alignment or failed_quality_control or supplementary)"',
               '--format bam',
               '--nthreads', threads,
               '--output-filename', out_bam))

  # calculate mean insert size
  wr_in_size <- system(paste(samtools, 'view', out_bam, '| head -n', as.integer(size_subsample)), intern = T)

  b_sum = 0
  b_count = 0
  numlines = 0

  for(line in wr_in_size){
    numlines <- numlines + 1
    tmp <-  unlist(strsplit(line, "\t"))

    if(length(tmp) < 9) break

    if(abs(as.integer(tmp[8])) < 10000){
      b_sum <-  b_sum + abs(as.integer(tmp[8]))
      b_count <-  b_count + 1
    }
  }

  mean = b_sum / b_count
  conf_tmp <- paste(tumor_file, mean, gsub("\\..*$", "", basename(tumor_file)), collapse = "\t")

  return(conf_tmp)
}

#' sambambaIndex
#'
#' @description
#' Generate BAM index if it is not present using sambamba
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' sambambaIndex(bam = 'raw/sample_tumor.bam',
#'             threads = 2,
#'             sambamba = '/bin/sambamba')
#'}
#'
#' @export
sambambaIndex <- function(bam,
                          threads,
                          sambamba){

  index <- paste0(bam, '.bai')

  if(!file.exists(index)){

    message(paste(Sys.time(),"\n",
                  'Index for', bam, 'not present.\n\n',
                  'Starting BAM index generation using:\n',
                  '>BAM file:', bam, '\n',
                  '>Number of threads:', threads, '\n'))

    system(paste(sambamba, "index",
                 "-t", threads,
                 bam))

    message(paste(Sys.time(),"\n", 'Finished', bam, '\n'))

  }
}

#' sambambaIndex
#'
#' @description
#' Generate BAM index if it is not present using sambamba
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' sambambaIndex(bam = 'raw/sample_tumor.bam',
#'             threads = 2,
#'             sambamba = '/bin/sambamba')
#'}
#'
#' @export
samtoolsIndex <- function(bam,
                          threads,
                          samtools){

  index <- paste0(bam, '.bai')

  if(!file.exists(index)){

    message(paste(Sys.time(),"\n",
                  'Index for', bam, 'not present.\n\n',
                  'Starting BAM index generation using:\n',
                  '>BAM file:', bam, '\n',
                  '>Number of threads:', threads, '\n'))

    system(paste(samtools, "index",
                 "-@", threads,
                 bam))

    message(paste(Sys.time(),"\n", 'Finished', bam, '\n'))

  }
}

#' radia
#'
#' @description
#' Tumor-normal pair somatic variant calling using RADIA
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' radiaCalling(tumor_file = 'raw/sample_tumor.bam',
#'                normal_file = 'raw/sample_normal.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                radia_path = '/bin/radia/scripts',
#'                python_radia = 'venv/radia/bin/python',
#'                samtools = '/bin/samtools')
#'}
#'
#' @export
radiaCalling <- function(tumor_file,
                         normal_file,
                         sample_name,
                         ref,
                         out_path,
                         radia_path,
                         python_radia,
                         samtools,
                         threads,
                         bcftools){
  # define output
  out_path <- file.path(out_path, "radia")
  dir.create(out_path, showWarnings = F)
  out_radia <- file.path(out_path, paste0(sample_name, "_out_radia"))
  out_radia_filtered <- file.path(out_path, 'filtered')
  dir.create(out_radia_filtered, showWarnings = F)

  radia <- file.path(radia_path, 'radia.py')
  merge_chroms <- file.path(radia_path, 'mergeChroms.py')
  filter_radia <- file.path(radia_path, 'filterRadia.py')
  radia_data <- paste0(dirname(radia_path), '/data')
  #TODO: advice same ref name and ref radia folder
  ref_name <- gsub(".fa", "",basename(ref))

  message(paste(Sys.time(),"\n",
                'Starting RADIA calling using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Normal file:', normal_file, '\n',
                '>Sample name:', sample_name, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_radia, '\n',
                '>Number of threads:', threads, '\n'))


  # define chr in BAM file
  chr_ti <- system(paste(samtools, 'idxstats', tumor_file, "| cut -f 1 | sed -e '$ d'"), intern = T)
  chr_bl <- system(paste(samtools, 'idxstats', normal_file, "| cut -f 1 | sed -e '$ d'"), intern = T)
  chr_list <- unique(c(chr_ti, chr_bl))

  # set parallel parameters
  cl <- parallel::makeCluster(threads)
  doParallel::registerDoParallel(cl)


  # radia calling in parallel
  `%dopar%` <- foreach::`%dopar%`

  foreach::foreach(chr=chr_list) %dopar% {
    system(paste(python_radia, radia,
                 sample_name,
                 chr,
                 '-n', normal_file,
                 '-t', tumor_file,
                 '-f', ref,
                 '-o', paste0(out_radia, "_", chr, ".vcf")))

    # system(paste(python_radia, filter_radia,
    #              sample_name,
    #              chr,
    #              paste0(out_radia, "_", chr, ".vcf"),
    #              radia_path,
    #              out_radia_filtered,
    #              '--dnaOnly',
    #              '--noSnpEff',
    #              '--noRadar',
    #              '--noDarned',
    #              '--ignoreScriptsDir',
    #              '-b', file.path(radia_data, ref_name, 'blacklists/1000Genomes/phase3'),
    #                '-d', file.path(radia_data, ref_name, 'snp151'),
    #                '-r', file.path(radia_data, ref_name, 'retroGenes'),
    #              '-t', file.path(radia_data, ref_name, 'gencode/basic'),
    #                '-p', file.path(radia_data, ref_name, 'pseudoGenes'),
    #                '-c', file.path(radia_data, ref_name, 'cosmic')))


  }

  # merge temporal vcfs
  system(paste(python_radia, merge_chroms,
               paste0(sample_name, "_out_radia"),
               out_path,
               out_path))

  # remove temporal vcfs
  tmp_vcf <- list.files(out_path,
                        full.names = T)

  tmp_vcf <- c(tmp_vcf, file.path(out_path, paste0(sample_name, "_out_radia.vcf")))

  tmp_vcf <- tmp_vcf[!(duplicated(tmp_vcf)|duplicated(tmp_vcf, fromLast=TRUE))]

  lapply(tmp_vcf, unlink)


  pass_vcf <- file.path(out_path, paste0(sample_name, '_radia_PASS.vcf'))

  system(paste(bcftools, 'view',
               '-f PASS', file.path(out_path, paste0(sample_name, "_out_radia.vcf")),
               '>', pass_vcf))

  # remove IUPAC ambiguity
  tmp_vcf <- gsub('\\..*$', '_tmp.vcf', pass_vcf)
  tmp_header <- gsub('\\..*$', '_tmp_h.vcf', pass_vcf)


  system(paste(bcftools,
               'view -H', pass_vcf,
               '| awk \'($4=="A")||($4=="T")||($4=="G")||($4=="C") {print}\' >', tmp_vcf))

  system(paste(bcftools,
               'view -h', pass_vcf,
               '>', tmp_header))

  unlink(pass_vcf)

  system(paste('cat', tmp_header, tmp_vcf, '>', pass_vcf))

  unlink(tmp_vcf)
  unlink(tmp_header)

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}

#' bcftoolsReheader
#'
#' @description
#' Parser for bcftools reheader
#'
#' @inheritParams variantCalling
#' @param vcf Vcf to reheader.
#' @param vcf_new_names Vector with the new sample names to define in the vcf header.
#' @param reheadered_vcf Path where to save the reheared vcf.
#' @examples
#' \dontrun{
#' bcftoolsReheader(bcftools = 'bcftools', vcf = 'sample.vcf', vcf_new_names = c('NORMAL', 'TUMOR'), reheadered_vcf = 'sample_rh.vcf')
#'}
#' @export

bcftoolsReheader <- function(bcftools,
                             vcf,
                             vcf_new_names = c('NORMAL', 'TUMOR'),
                             reheadered_vcf){

  vcf_old_names <- system(paste(bcftools,
                                'query -l', vcf), intern = T)

  new_header_file <- file.path(dirname(vcf), paste0(sample_name, '.header'))

  new_header_vcf <- paste(c(vcf_old_names[1], " ",
                            vcf_new_names[1], '\n',
                            vcf_old_names[2], " ",
                            vcf_new_names[2]),
                          collapse = "")

  writeLines(new_header_vcf, new_header_file)

  system(paste(bcftools,
               'reheader',
               '-s', new_header_file,
               '-o',reheadered_vcf,
               vcf))

}


#' fpfilterTool
#'
#' @description
#' False postive filter parser for label low quality reads
#'
#' @inheritParams variantCalling
#' @examples
#' \dontrun{
#' fpfilterTool(vcf = 'vcf/sample.vcf',
#'              tumor_file = 'raw/sample_tumor.bam',
#'                sample_name = 'sample'
#'                ref = 'ref/hg38.fa',
#'                out_path = 'rst',
#'                perl = 'perl',
#'                fpfilter = 'fpfilter-tool/fpfilter.pl',
#'                bam_readcount = 'bam_readcount')
#'}
#' @export
fpfilterTool <- function(vcf,
                         tumor_file,
                         sample_name,
                         ref,
                         fpfilter,
                         perl,
                         out_path,
                         bam_readcount,
                         tumor_vcf_id='TUMOR'){
  # define output
  out_path <- dirname(vcf)
  out_fpfilter <- file.path(out_path, "fpfilter")
  dir.create(out_fpfilter, showWarnings = F)
  out_fpfilter_name <- file.path(out_fpfilter, sample_name)
  snvs_var <- paste0(out_fpfilter_name, "_snvs.var")
  snvs_readcount <- paste0(out_fpfilter_name, "_snvs.readcount")
  vcf_filtered <- paste0(out_fpfilter_name, ".vcf")

  message(paste(Sys.time(),"\n",
                'Starting fpfilter filtering using:\n',
                '>Tumor file:', tumor_file, '\n',
                '>Vcf:', vcf, '\n',
                '>Reference genome:', ref, '\n',
                '>Output path:', out_fpfilter, '\n'))

  # get vcf sample names
  vcf_names <- system(paste(bcftools,
                            'query -l',
                            vcf), intern = T)

  if(!tumor_vcf_id %in% vcf_names) {
    message('Wrong tumor vcf sample name')
    break()
  }

  # filter using fpfilter
  system(paste(perl, fpfilter,
               '--vcf-file', vcf,
               '--bam-file', tumor_file,
               '--reference', ref,
               '--output', vcf_filtered,
               '--sample', tumor_vcf_id))

  message(paste(Sys.time(),"\n", 'Finished', sample_name, '\n'))

}


#' postCalling
#'
#' @description
#' Vcf sorting, normalization and reheader of the vcf generated unsing `variantCalling` for posterior annotation. Input file have to
#' present the *_PASS.vcf format and being uncompressed.
#'
#' @inheritParams variantCalling
#' @param pass_vcf Vcf to apply post-calling processing. It should be descompressed and *_PASS.vcf format.
#' @examples
#' \dontrun{
#' postCalling(pass_vcf = 'raw/sample_tumor.bam',
#'             gatk4 = 'bin/gatk-4.1.3.0/gatk',
#'             ref = 'ref/hg38.fa',
#'             bcftools = 'bcftools')
#' }
#'
#' @export
postCalling <- function(pass_vcf,
                        gatk4,
                        ref,
                        bcftools){

  message(paste(Sys.time(),"\n",
                'Starting post-calling vcf using:\n',
                '>Vcf file:', pass_vcf, '\n',
                '>Reference genome:', ref, '\n'))

  # correct format vcf
  corr_vcf <- gsub("_PASS.vcf", "_corr.vcf", pass_vcf)

  system(paste(gatk4,
               "--java-options '-Xmx8g'",
               'SelectVariants',
               '-V', pass_vcf,
               '-O', corr_vcf,
               '-R', ref))

  # sort vcf
  sorted_vcf <- gsub("_corr.vcf", "_sorted.vcf", corr_vcf)

  system(paste(gatk4,
               'SortVcf',
               '--CREATE_INDEX=true',
               '--SEQUENCE_DICTIONARY', gsub(".fa", ".dict", ref),
               '-I', corr_vcf,
               '-O', sorted_vcf))

  unlink(corr_vcf)
  unlink(paste0(corr_vcf, '.idx'))


  # normalization
  n_vcf <- gsub("_sorted.vcf", "_n.vcf", sorted_vcf)
  system(paste(bcftools, 'norm',
               '-f', ref,
               sorted_vcf,
               '>', n_vcf))

  unlink(sorted_vcf)
  unlink(paste0(sorted_vcf, '.idx'))


  # rehader
  reheadered_vcf <- gsub("_n.vcf", "_postCalling.vcf", n_vcf)
  bcftoolsReheader(bcftools = bcftools,
                   vcf = n_vcf,
                   reheadered_vcf = reheadered_vcf)

  unlink(n_vcf)

}


