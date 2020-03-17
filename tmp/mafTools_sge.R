cores = 1
name = 'mafTools'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = paste('Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/mafTools.R')
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)



