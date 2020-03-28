tsv_path <- '/home/labs/lplab/msubirana/score-client/score-client-2.2.1'

tsvs <- list.files(tsv_path,
                   pattern = "\\.*.tsv$",
                   full.names = T)

tsv_table_all <- data.frame()

for(tsv in tsvs){
  tsv_table <- read.table(tsv,
                          header = T)
  tsv_table_all <- rbind(tsv_table_all, tsv_table)
}

tsv_table_all$file_name <- lapply(tsv_table_all$file_name, function(x) gsub('.bam', '', x))

path <- '/media/msubirana/plab1/icgc_downloads'

for(i in seq(nrow(tsv_table_all))){
  system(paste0('rename ',
                '\'s/',
                tsv_table_all$file_name[i],
                '/', tsv_table_all$file_id[i],
                '/\' ',
                path, '/*'))
}

csv_file <- '/imppc/labs/lplab/share/marc/insulinomas/raw/rename_pnets.csv'
csv <- read.csv(csv_file, header = F)
colnames(csv) <- c('icgc_name', 'erg_name')
path <- ''

for(i in seq(nrow(csv))){
  system(paste0('rename ',
                '\'s/',
                csv$icgc_name[i],
                '/', csv$erg_name[i],
                '/\' ',
                path, '*'))
  }

