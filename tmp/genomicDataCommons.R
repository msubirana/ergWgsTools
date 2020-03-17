library(GenomicDataCommons)
library(maftools)

GenomicDataCommons::status()

cases_by_project <- cases() %>%
  facet("TCGA-PAAD") %>%
  aggregations()
head(cases_by_project)
