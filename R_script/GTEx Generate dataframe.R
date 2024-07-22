#240722 GTEx portalからダウンロードした健常人の遺伝子発現パターンを読み込む

rm(list=ls())
library(data.table)

# GCTファイルを読み込む
#GCTファイルの場合、通常最初の2行はメタデータを含むヘッダーなので、skip=2 を使用してこれらをスキップし、実際のデータ行から読み込みを開始することが一般的です.
file_path <- "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/gene_tpm_2017-06-05_v8_pancreas.gct"
gtex_data <- fread(file_path, header = TRUE, sep = "\t", skip = 2)
# データの確認、行列数
print(dim(gtex_data))


