devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

input <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/vcf/strelka2/variants_sub.tsv'
regions <- file.path(getwd(),'regions.tsv')
output_dir <- file.path(getwd(), 'strelka2')
dir.create(output_dir,
           showWarnings = FALSE)
cores = 10
name = 'CLUST_11p15'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'

script = paste0('export LC_ALL=C.UTF-8\n',
               'export LANG=C.UTF-8\n',
               'export BGDATA_LOCAL=/imppc/labs/lplab/share/marc/refgen/oncodriveCLUSTL\n',
               'source /software/debian-8/general/virtenvs/oncodriveCLUSTL-v1.1.1-py3/bin/activate\n',
               paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/oncodriveclustl.R',
               input,
               regions,
               output_dir))

email = 'clusterigtpmsubirana@gmail.com'
RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)
