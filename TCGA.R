#240719 TCGA datasetをGTExと同じ形式にする。
#まずターミナルで以下を実行する。ダウンロードしたtsvファイルは、全てそれぞれのディレクトリが作られて保存されているので、tsvファイルをディレクトリから出す。
#dir="/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA/gdc_download_20240719_070341.317860"
#cd "$dir" || exit
#find . -mindepth 2 -type f -name "*.tsv" -exec mv {} . \;
#find . -mindepth 1 -type d -empty -delete


rm(list=ls())
library(dplyr)
library(purrr)
library(readr)
library(tidyr)

# TSVファイルが格納されているディレクトリのパスと、出力先のディレクトリのパス
directory_path <- "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA/gdc_download_20240719_070341.317860"
output_path <- "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA/TCGA R output"
current_dir <- "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240719 normal vs cancer TCGA-BRCA"

# R_processディレクトリのパスを設定
TCGA_R_output_dir <- file.path(current_dir, "TCGA R output")

# ディレクトリが存在しない場合のみ作成
if (!dir.exists(TCGA_R_output_dir)) {
  dir.create(TCGA_R_output_dir)
  cat("R_processディレクトリが作成されました：", TCGA_R_output_dir, "\n")
} else {
  cat("R_processディレクトリは既に存在します：", TCGA_R_output_dir, "\n")
}

# 出力ファイルのパス
output_file <- file.path(output_path, "combined_extracted_columns.tsv")

# ディレクトリ内のすべてのTSVファイルのリストを取得
tsv_files <- list.files(path = directory_path, pattern = "*.tsv", full.names = TRUE, recursive = TRUE)

# 各ファイルの7列目を抽出し、連結する関数
extract_and_combine <- function(file_paths) {
  file_paths %>%
    map_dfc(~{
      # ファイル名（拡張子なし）を取得
      base_name <- tools::file_path_sans_ext(basename(.x))
      
      # ファイルを読み込む（ヘッダーをスキップし、タブ区切りを指定）
      data <- read_tsv(.x, skip = 2, col_names = FALSE, col_types = cols(.default = "c"))
      
      if (ncol(data) >= 7) {
        extracted <- data %>% 
          select(7) %>% 
          rename(!!base_name := 1)  # 列名をファイル名に設定
        
        # 数値に変換を試みる
        extracted %>% mutate(across(everything(), ~as.numeric(.)))
      } else {
        tibble(!!base_name := rep(NA_real_, nrow(data)))  # 7列目がない場合はNA列を作成
      }
    })
}

# 全てのTSVファイルから7列目を抽出し、連結
combined_data <- extract_and_combine(tsv_files)

# 結果を確認
print(dim(combined_data))
print(head(combined_data))

# 結果を新しいTSVファイルとして保存
write_tsv(combined_data, output_file)

cat("連結されたデータが以下のファイルに保存されました：", output_file, "\n")




#gene idとかを追記する
# 出力ファイルのパス
final_output_file <- file.path(output_path, "final_combined_with_gene_info.tsv")

# 結合するファイルのパス、適当なtsvファイルを選んでいる。
reference_file <- file.path(directory_path, "0a9e33db-2527-4cc3-8669-a7c10fed7a7f.rna_seq.augmented_star_gene_counts.tsv")

# 抽出したデータのファイルのパス
combined_file <- file.path(output_path, "combined_extracted_columns.tsv")

# reference_fileからgene_idとgene_nameを抽出
reference_data <- read_tsv(reference_file, skip = 2, col_names = FALSE)

# gene_idとgene_nameを取得（1列目と2列目）
gene_info <- reference_data %>%
  select(1, 2) %>%
  rename(gene_id = 1, gene_name = 2)

# 抽出したデータを読み込む
combined_data <- read_tsv(combined_file)

# gene_idとgene_nameを結合
final_data <- bind_cols(gene_info, combined_data)

print(head(final_data))

# 結果を新しいTSVファイルとして保存
write_tsv(final_data, final_output_file)

cat("最終的なデータが以下のファイルに保存されました：", final_output_file, "\n")



#いらない行を消す

# 入力ファイルのパス
input_file <- file.path(output_path, "final_combined_with_gene_info.tsv")

# 出力ファイルのパス
clean_output_file <- file.path(output_path, "final_combined_with_gene_info_cleaned.tsv")

# ファイルを読み込む
data <- read_tsv(input_file)

# 先頭1行から4行を削除
cleaned_data <- data %>% slice(-(1:4))

# 結果を新しいTSVファイルとして保存
write_tsv(cleaned_data, clean_output_file)

cat("クリーニングされたデータが以下のファイルに保存されました：", clean_output_file, "\n")

# 結果の確認（最初の数行を表示）
print(head(cleaned_data))
