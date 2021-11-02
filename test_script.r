library(tibble)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(reshape2)
library(scales)

# Read data
data <- read.csv("breast-cancer-wisconsin.data", na.strings = '?')
# Convert to tibble for readability later on
data <- as_tibble(data)
# Set column names
colnames(data) <- c("id", "Clump_Thickness", "Cell_Size_Uniformity", "Cell_Shape_Uniformity",                        "Marginal_Adhesion", "Single_Epithelial_Cell_Size", "Bare_Nuclei",
                    "Bland_Chromatin", "Normal_Nucleoli", "Mitoses", "Class")

# Make correlation matrix
cormat <- cor(na.omit(data[, -1]))
# Melt to correct format
melted.cormat <- melt(cormat, value.name = "Correlation")
# head(melted.cormat) # <- uncomment this to look at the new matrix

# Make heatmap with ggplot
par(mfrow = c(1, 2))
ggplot(data = melted.cormat, aes(x=Var1, y=Var2, fill=Correlation)) + 
  geom_tile() + # geom_tile makes the heatmap tiles
  scale_fill_gradient(low = rgb(0, 0, 0),
                      high = rgb(0, 1, 1),
                      guide = "colorbar") + # sets color the gradient for tiles
  ylab('') +
  xlab('') + # the x and y axes have no useful names, and are thus left blank
  labs(caption =
         "Figure 1 ~ Correlation Heatmap of the breast cancer data set.
      The lighter the color, the better the correlation between the two columns.") + # adds caption
  theme_minimal() + # set theme to minimal
  theme(axis.text.x = element_text(angle = 45, hjust = 1), # adjust x labels to be diagonal
        plot.caption = element_text(hjust = 0.7)) # adjust caption position


# Get class counts
m.count <- length(data$Class[data$Class == 'M'])
b.count <- length(data$Class[data$Class == 'B'])
# Combine in data frame
count.data <- data.frame(Class = c('Malignant', 'Benign'), Value = c(m.count, b.count))

count.data %>%
  arrange(desc(Value)) %>%
  mutate(prop = percent(Value / sum(Value),  accuracy = 0.1)) -> count.data 

# Make pie chart
ggplot(count.data, aes(x = "", y = Value, fill = Class)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  geom_label_repel(aes(label = prop), size=5, show.legend = F, nudge_x = -1, segment.colour= NA) +
  labs(caption="Figure 2 ~ A pie chart of the distrubtion of the classes in the dataset.") +
  theme_void() +
  theme(plot.caption = element_text(hjust = 1))


