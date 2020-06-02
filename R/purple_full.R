purple_full <- function(control_name,
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
                        strelka_merged_annotated_reheader,
                        strelka_merged_annotated_reheader_pass,
                        output_dir_purple){

  cobalt(control_name=control_name,
         control=control,
         tumor_name=tumor_name,
         tumor=tumor,
         output_dir_cobalt=output_dir_cobalt,
         threads=threads)

  amber(control_name=control_name,
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
               strelka_merged_annotated_reheader_pass=strelka_merged_annotated_reheader_pass,
               tumor_name=tumor_name,
               strelka_merged_annotated_reheader=strelka_merged_annotated_reheader)

  purple(control_name=control_name,
         control=control,
         tumor_name=tumor_name,
         tumor=tumor,
         output_dir_purple=output_dir_purple,
         output_dir_cobalt=output_dir_cobalt,
         output_dir_amber=output_dir_amber,
         threads=threads,
         somatic_vcf=strelka_merged_annotated_reheader)

}

