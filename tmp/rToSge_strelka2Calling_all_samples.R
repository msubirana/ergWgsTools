library(RtoSge)

# strelka2Calling
cores = 24
name = 'all_samples_strelka2Calling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/strelka2Calling_all_samples.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)
