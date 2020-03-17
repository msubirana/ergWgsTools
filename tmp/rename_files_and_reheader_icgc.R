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

path <- '/imppc/labs/lplab/share/marc/icgc_downloads'

for(i in seq(nrow(tsv_table_all))){
  system(paste0('rename ',
                '\'s/',
                tsv_table_all$file_name[i],
                '/', tsv_table_all$file_id[i],
                '/\' ',
                path, '/*'))
}
