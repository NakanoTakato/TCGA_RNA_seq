#240719 calculate mean and SE of each gene (Ex: BCAT1) GTEx

rm(list=ls())

library(dplyr)
library(tidyr)
library(purrr)


# 元のデータフレームを読み込む
original_df <- read_tsv("Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA/TCGA R output/final_combined_with_gene_info_cleaned.tsv")


# BCAT1 を含む行を抽出し、新しいデータフレームを作成
BCAT1 <- original_df %>%
  filter(gene_name == "BCAT1")

# 結果を確認
print(BCAT1)

# 行数を確認
cat("BCAT1 データフレームの行数:", nrow(BCAT1), "\n")

# 新しいデータフレームを TSV ファイルとして保存（オプション）
write_tsv(BCAT1, "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA/TCGA R output/BCAT1_data.tsv")
cat("BCAT1 データが TCGA R output/BCAT1_data.tsv に保存されました。\n")




library(dplyr)
library(tidyr)

# BCAT1データフレームを読み込む（既に読み込んでいる場合はこの行は不要です）
# BCAT1 <- read_tsv("R_process/BCAT1_data.tsv")

# 3列目以降の数値データの行ごとの平均と標準誤差を計算
results <- BCAT1 %>%
  mutate(
    row_mean = rowMeans(select(., 3:ncol(.)), na.rm = TRUE),
    row_se = apply(select(., 3:ncol(.)), 1, function(x) sd(x, na.rm = TRUE) / sqrt(sum(!is.na(x))))
  ) %>%
  select(gene_id, gene_name, row_mean, row_se)

# 結果を表示
print(results)

# 結果をファイルに保存（オプション）
write_tsv(results, "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA/TCGA R output/BCAT1_row_summary_stats.tsv")


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
write_tsv(results, "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA/TCGA R output/meanSE.tsv")
