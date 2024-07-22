#240722 calculate mean and SE of each gene (Ex: BCAT1) TCGA

rm(list=ls())

library(dplyr)
library(tidyr)
library(purrr)


# 元のデータフレームを読み込む
original_df <- read_tsv("/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/TCGA R output/final_combined_with_gene_info_cleaned.tsv")


#各行のMeanとSEを計算
results <- original_df %>%
  mutate(
    row_mean = rowMeans(select(., 3:ncol(.)), na.rm = TRUE),
    row_se = apply(select(., 3:ncol(.)), 1, function(x) sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x))))
  ) %>%
  select(gene_id, gene_name, row_mean, row_se)

# 結果を表示
print(results)

# 結果をファイルに保存（オプション）
write_tsv(results, "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/TCGA R output/meanSE.tsv")
