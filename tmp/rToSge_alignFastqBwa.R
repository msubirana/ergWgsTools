library(RtoSge)

# alignFastqBwa
cores = 16
name = 'NET-25_ergWgsTools_alignFastqBwa'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/alignFastqBwa.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)
