#240722 calculate mean and SE of each gene GTEx

rm(list=ls())

library(dplyr)
library(tidyr)
library(purrr)


# GCTファイルを読み込む
#GCTファイルの場合、通常最初の2行はメタデータを含むヘッダーなので、skip=2 を使用してこれらをスキップし、実際のデータ行から読み込みを開始することが一般的です.
file_path <- "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/gene_tpm_2017-06-05_v8_pancreas.gct"
gtex_data <- fread(file_path, header = TRUE, sep = "\t", skip = 2)
# データの確認、行列数
print(dim(gtex_data))
head(gtex_data)


#各行のMeanとSEを計算
results <- gtex_data %>%
  rowwise() %>%
  mutate(
    mean_expression = mean(c_across(4:ncol(.)), na.rm = TRUE),
    se_expression = sd(c_across(4:ncol(.)), na.rm = TRUE) / sqrt(sum(!is.na(c_across(4:ncol(.)))))
  ) %>%
  ungroup() %>%
  select(Description, Name, mean_expression, se_expression)

# 結果を表示
print(results)

# 結果をファイルに保存（オプション）
write_tsv(results, "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/GTEx_meanSE.tsv")