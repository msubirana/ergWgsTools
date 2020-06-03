devtools::load_all('/imppc/labs/lplab/share/marc/repos/ergWgsTools')
control_name='NET-59_BL'
control='/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/NET-59_BL.bam'
tumor_name='NET-59_TI'
tumor='/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/NET-59_TI.bam'
output_dir_gridss='/imppc/labs/lplab/share/marc/insulinomas/processed/hg38/bam/bwa/gridss'
dir.create(output_dir_gridss, showWarnings = F)
threads=16

gridss(control_name=control_name,
       control=control,
       tumor_name=tumor_name,
       tumor=tumor,
       output_dir_gridss=output_dir_gridss,
       threads=threads)
