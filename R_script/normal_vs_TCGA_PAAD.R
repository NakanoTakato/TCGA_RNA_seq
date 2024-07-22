#240722 normal vs tumor expression comparison


rm(list=ls())
# 必要なパッケージの読み込み
library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

# CSVファイルのパスを指定
file_path <- "/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/normal_vs_tumor.csv"

# データを読み込む
data <- read_csv(file_path)

# データの型を確認
str(data)

# データの整形と0を含む行の削除
plot_data <- data %>%
  select(gene_id, gene_name, 
         normal_mean, normal_se, 
         tumor_mean, tumor_se) %>%
  pivot_longer(cols = c(normal_mean, normal_se, tumor_mean, tumor_se),
               names_to = c(".value", "condition"),
               names_pattern = "(.*)_(.*)") %>%
  pivot_longer(cols = c(normal, tumor),
               names_to = "tissue",
               values_to = "value") %>%
  mutate(condition = ifelse(condition == "mean", "mean", "se"),
         tissue = ifelse(tissue == "normal", "Normal", "Tumor")) %>%
  pivot_wider(names_from = condition, values_from = value) %>%
  filter(mean != 0 & se != 0)


# tissueごとにmeanの総和を計算
summarized_data <- plot_data %>%
  group_by(tissue) %>%
  summarise(total_mean = sum(mean, na.rm = TRUE))

# 結果を確認
print(summarized_data)

# TPMの総和をプロットして保存
Total_TPM_plot <- ggplot(summarized_data, aes(x = tissue, y = total_mean, fill = tissue)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Total Mean by Tissue",
       x = "Tissue",
       y = "Total Mean of TPM") +
  scale_fill_manual(values = c("Normal" = "blue", "Tumor" = "red"))

ggsave("/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/Total_TPM.png", plot = Total_TPM_plot, width = 8, height = 6, dpi = 300)




# RYK遺伝子のデータをフィルタリング
RYK_data <- plot_data %>%
  filter(gene_name == "RYK")

# データの確認
print(RYK_data)
# RYK遺伝子のグラフ作成
RYK_plot <- ggplot(RYK_data, aes(x = tissue, y = mean, fill = tissue)) +
  geom_bar(stat = "identity", position = position_dodge(), width = 0.7) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se), 
                width = 0.2, 
                position = position_dodge(0.7)) +
  labs(title = "RYK Gene Expression: Normal Tissue vs TCGA PAAD Tumor",
       x = "Condition",
       y = "TPM") +
  theme_minimal() +
  theme(legend.position = "none") +  # 凡例を削除
  scale_fill_manual(values = c("Normal" = "blue", "Tumor" = "red"))  # 色を指定

# グラフを表示
print(RYK_plot)

# グラフを保存
ggsave("/Users/nakanotakato/Desktop/2024 Igaki lab/Data/2407/RNAseq 240722 TCGA_PAAD/Plot pngRYK_expression_plot.png", plot = RYK_plot, width = 8, height = 6, dpi = 300)
