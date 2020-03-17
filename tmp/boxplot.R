library(ggplot2)
library(cowplot)

sstr2gs <- read.table('/imppc/labs/lplab/share/marc/other/SSTR2GS.txt', sep = '\t', header = T)

library(ggpubr)
library(ggsignif)

library(tibble)
sstr2gs <- as_tibble(sstr2gs)
# Calculate annotation
pvalue <- kruskal.test(SSTR2.IHC~SRL.response, data = sstr2gs)$p.value
pvalue <- format(round(pvalue, 3), nsmall = 2)
my_comparisons <- list( c("CR", "NR"), c("PR", "NR"), c("CR", "PR"))
anno <- compare_means(SSTR2.IHC ~ SRL.response,  data = sstr2gs)$p
anno <- unlist(lapply(anno, function(x) format(round(x, 3), nsmall = 2)))

ggplot(sstr2gs, aes(x = SRL.response, y = SSTR2.IHC)) +
  ylab('H-score') +
  xlab('SRL Response') +
  theme(legend.position = "none") +
  geom_signif(comparisons = list(c("CR", "NR")), annotations = anno[1], tip_length = 0.03, y_position = 310, map_signif_level = TRUE) +
  geom_signif(comparisons = list(c("PR", "NR")), annotations = anno[2], tip_length = 0.03, y_position = 310, map_signif_level = TRUE) +
  geom_signif(comparisons = list(c("CR", "PR")), annotations = anno[3], tip_length = 0.03, y_position = 330, map_signif_level = TRUE) +
  geom_boxplot(aes(color = sstr2gs$SRL.response)) +
  annotate('text', x=0.8, y=350, label= paste('p =', pvalue), size = 5)



