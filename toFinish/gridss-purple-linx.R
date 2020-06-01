install_dir='/imppc/labs/lplab/share/bin/gridss-purple-linx/'
gcprofile='/imppc/labs/lplab/share/marc/refgen/purple/GC_profile.hg38.1000bp.cnp'
repeatmasker=''
blacklist='/imppc/labs/lplab/share/marc/refgen/hg38/hg38-blacklist.v2.bed'
bafsnps='/imppc/labs/lplab/share/marc/refgen/purple/GermlineHetPon.hg38.vcf.gz'

system(paste0('install_dir=',install_dir,'\n'),
'GRIDSS_VERSION=2.6.2\n',
'COBALT_VERSION=1.7\n',
'PURPLE_VERSION=2.34\n',
'LINX_VERSION=1.4\n',
'export GRIDSS_JAR=$install_dir/gridss/gridss-${GRIDSS_VERSION}-gridss-jar-with-dependencies.jar\n',
'export AMBER_JAR=$install_dir/hmftools/amber-${AMBER_VERSION}-jar-with-dependencies.jar\n',
'export COBALT_JAR=$install_dir/hmftools/count-bam-lines-${COBALT_VERSION}-jar-with-dependencies.jar\n',
'export PURPLE_JAR=$install_dir/hmftools/purity-ploidy-estimator-${PURPLE_VERSION}-jar-with-dependencies.jar\n',
'export LINX_JAR=$install_dir/hmftools/sv-linx-${LINX_VERSION}-jar-with-dependencies.jar\n')),

'$install_dir/gridss-purple-linx/gridss-purple-linx.sh',
'-n ', control,
'-t ', tumor,
'-s ', sample,
'--normal_sample ', control_name,
'--tumour_sample ', tumor_name,
'--snvvcf ', strelka_merged_annotated_reheader,
'--ref_dir ', refdata \
'--install_dir ', install_dir \
'--rundir ', run_dir,
'--reference', reference,
'--gcprofile', gcprofile,
'--repeatmasker', repeatmasker,
'--blacklist', blacklist,
'--bafsnps', bafsnps
