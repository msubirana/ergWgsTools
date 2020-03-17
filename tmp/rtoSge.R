library(RtoSge)


cores = 28
name = 'ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/test.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)
