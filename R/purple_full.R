purple_full <- function(control_mame,
                        control,
                        tumor_name,
                        tumor,
                        output_dir_cobalt,
                        threads,
                        output_dir_amber,
                        refgen,
                        strelka_snvs,
                        strelka_indels,
                        strelka_merged,
                        strelka_merged_annotated,
                        output_dir_purple){

  cobalt(control_mame=control_mame,
         control=control,
         tumor_name=tumor_name,
         tumor=tumor,
         output_dir_cobalt=output_dir_cobalt,
         threads=threads)

  amber(control_mame=control_mame,
        control=control,
        tumor_name=tumor_name,
        tumor=tumor,
        output_dir_amber=output_dir_amber,
        threads=threads)


  mergeStrelka(refgen=refgen,
               strelka_snvs=strelka_snvs,
               strelka_indels=strelka_indels,
               control_name=control_name,
               strelka_merged=strelka_merged,
               strelka_merged_annotated=strelka_merged_annotated,
               tumor_name=tumor_name)

  purple(control_mame=control_mame,
         control=control,
         tumor_name=tumor_name,
         tumor=tumor,
         output_dir_purple=output_dir_purple,
         output_dir_cobalt=output_dir_cobalt,
         output_dir_amber=output_dir_amber,
         threads=threads,
         somatic_vcf=strelka_merged_annotated)

}
