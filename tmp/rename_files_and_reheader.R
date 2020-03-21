df_rename <- data.frame('new_names' = c('NET-49_BL',
                                      'NET-49_TI',
                                      'NET-50_BL',
                                      'NET-50_TI',
                                      'NET-51_BL',
                                      'NET-51_TI',
                                      'NET-52_BL',
                                      'NET-52_TI',
                                      'NET-53_BL',
                                      'NET-53_TI'),

                        'old_names' = c('NET-40_BL',
                                      'NET-40_TI',
                                      'NET-41_BL',
                                      'NET-41_TI',
                                      'NET-42_BL',
                                      'NET-42_TI',
                                      'NET-43_BL',
                                      'NET-43_TI',
                                      'NET-44_BL',
                                      'NET-44_TI')
)

path <-  '/media/msubirana/IGTP20228/insulinomas/processed/hg38/bam/bwa'

for(i in seq(nrow(df_rename))){
  system(paste0('rename ',
         '\'s/',
         df_rename$old_names[i],
         '/', df_rename$new_names[i],
         '/\' ',
         path, '/*'))
}

devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')

bams <- list.files('/media/msubirana/IGTP20228/insulinomas/processed/hg38/bam/bwa/forRh',
                   pattern = '\\.bam$',
                   full.names = T)

out_path <- '/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/reheader'

for(bam in bams){

  reheaderBam(bam = bam, out_path = out_path)

}

