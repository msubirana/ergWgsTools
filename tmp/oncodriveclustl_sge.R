devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

input <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/vcf/INS_REs_oncodrive_sub.regions'
regions <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/INS_REs_oncodrive.regions.gz'
output_dir <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/vcf/oncodriveclustl_results'
genome <- 'hg38'
cores = 28
name = 'odCLUST_insu'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'

script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/oncodriveclustl.R',
               input,
               regions,
               output_dir,
               genome)

email = 'clusterigtpmsubirana@gmail.com'
RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              memmory = memmory,
              script = script,
              email = email)
