#240720 normal vs tumor expression comparison


rm(list=ls())
# 必要なパッケージの読み込み
library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

# CSVファイルのパスを指定
file_path <- "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/GTEx_vs_TCGA_BRCA.csv"

# データを読み込む
data <- read_csv(file_path)

# データの型を確認
str(data)


# データの整形と0を含む行の削除
plot_data <- data %>%
  select(gene_name, 
         mean_normal_tissue, se_normal_tissue, 
         mean_TCGA_BRCA_tumor, se_TCGA_BRCA_tumor) %>%
  pivot_longer(cols = -gene_name,
               names_to = c(".value", "condition"),
               names_pattern = "(mean|se)_(.+)") %>%
  mutate(condition = ifelse(condition == "normal_tissue", "Normal", "Tumor")) %>%
  filter(mean != 0 & se != 0)  # 0を含む行を削除

# GAPDH遺伝子のデータをフィルタリング
GAPDH_data <- plot_data %>%
  filter(gene_name == "GAPDH")

# データの確認
print(GAPDH_data)

# GAPDH遺伝子のグラフ作成
GAPDH_plot <- ggplot(GAPDH_data, aes(x = condition, y = mean, fill = condition)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.7) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), 
                width = 0.2, 
                position = position_dodge(0.7)) +
  labs(title = "GAPDH Gene Expression: Normal Tissue vs TCGA BRCA Tumor",
       x = "Condition",
       y = "Mean Expression Level") +
  theme_minimal() +
  theme(legend.position = "none") +  # 凡例を削除
  scale_fill_manual(values = c("Normal" = "blue", "Tumor" = "red"))  # 色を指定

# グラフを表示
print(GAPDH_plot)

# グラフを保存
ggsave("/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/GAPDH_expression_plot.png", plot = GAPDH_plot, width = 8, height = 6, dpi = 300)

