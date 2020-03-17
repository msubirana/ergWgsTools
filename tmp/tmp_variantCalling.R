library(RtoSge)

# museCalling
cores = 1
name = 'museCalling_ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/museCalling.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)

# varscan2Calling
cores = 1
name = 'varScan2Calling_ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/varscan2Calling.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)

# pindelCalling
cores = 8
name = 'pindelCalling_ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/pindelCalling.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)

# strelka2Calling
cores = 8
name = 'strelka2Calling_ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/strelka2Calling.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)

# mutect2Calling
cores = 8
name = 'mutect2Calling_ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/mutect2Calling.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)

# radiaCalling
cores = 8
name = 'radiaCalling_ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/radiaCalling.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)

# somaticsniperCalling
cores = 1
name = 'somaticsniperCalling_ergWgsTools_variantCalling'
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
script = 'Rscript /imppc/labs/lplab/share/marc/repos/ergWgsTools/tmp/somaticsniperCalling.R'
email = 'clusterigtpmsubirana@gmail.com'

RtoSge::toSge(cores = cores,
              name = name,
              queue = queue,
              log = log,
              script = script,
              email = email)


