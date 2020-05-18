devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

input <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/vcf/strelka2/variants_sub.tsv'
regions <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/oncodriveCLUSTL/universe_all/regions.tsv'
main_dir <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/oncodrive/oncodriveCLUSTL/universe_all/fine_tuning'

dir.create(main_dir,
           showWarnings = FALSE)

cores = 2
queue = 'imppcv3'
log = '/imppc/labs/lplab/share/marc/insulinomas/logs'
email = 'clusterigtpmsubirana@gmail.com'

param <- list(simw = c(21, 31, 41), sw = c(11, 21, 31), cw = c(5, 11, 21))
df_param <- do.call(expand.grid, param)


for (row in 1:nrow(df_param)) {
  values <- df_param[row,]
  name = paste0('ft_', paste0(values, collapse = "_"))
  simw <- as.character(values[1])
  sw <- as.character(values[2])
  cw <- as.character(values[3])
  output_dir <- file.path(main_dir, name)
  dir.create(output_dir,
             showWarnings = FALSE)

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
                        cores))

  RtoSge::toSge(cores = cores,
                name = name,
                queue = queue,
                log = log,
                script = script,
                email = email)


}



