devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

input <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/vcf/strelka2/variants_sub.tsv'
cores = 10
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
email = 'clusterigtpmsubirana@gmail.com'
simw = 21
sw = 31
cw = 11
simw = 21
regions <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/oncodriveCLUSTL/simw21_sw31_cw11/regions/group_7_8.tsv'
out_dir <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/oncodriveCLUSTL/simw21_sw31_cw11/group_7_8'

emuts <- c(3,4,5,6)


for (emut in emuts) {

  output_dir <- file.path(out_dir, paste0('emut_', emut))
  dir.create(output_dir,
             showWarnings = FALSE)

  name = paste0('CLUSLT', emut)

  script = paste0('export LC_ALL=C.UTF-8\n',
                  'export LANG=C.UTF-8\n',
                  'export BGDATA_LOCAL=/imppc/labs/lplab/share/marc/refgen/oncodriveCLUSTL\n',
                  'source /software/debian-8/general/virtenvs/oncodriveCLUSTL-v1.1.1-py3/bin/activate\n',
                  paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/oncodriveclustl.R',
                        input,
                        regions,
                        output_dir,
                        sw,
                        simw,
                        cw,
                        cores,
                        emut))

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)


}



