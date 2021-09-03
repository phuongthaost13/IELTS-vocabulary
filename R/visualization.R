library(ggplot2)
library(hrbrthemes)
library(scales)
library(dplyr)
library(data.table)
library(tidytext)
library(purrr) 
#library(plyr) # k load package này bởi vì nó mask dplyr::group_by

# Tạo bộ dữ liệu để visualize

# data import
setwd("~/R project/textMining/ielts-vocab/output/cam10-15")
temp <- list.files(pattern = "*.csv")
myFiles <- lapply(temp, read.csv)

# Thêm tên cho các data frame trong list `myFiles`
len_myFiles <- length(myFiles)
for (i in 1:len_myFiles) {
  myFiles[[i]]$source <- paste("Cambridge", i+9)
}

# combine all dataframe into one
# Sau bước import data, object `myFiles` hiện tại đang ở dạng một list các data frame. Mình gộp chung các data frame này lại thành một df duy nhất.
# Sau đó, thêm một cột phân chia stopwords (sw) và normal words (nw)
combined_df <- bind_rows(myFiles)
len_cd <- nrow(combined_df)
for (i in 1:len_cd) {
  if (combined_df$word[i] %in% stop_words$word) {
  combined_df$word_type[i] = 'sw'
} else {
  combined_df$word_type[i] = 'nw'
}
}

# question sample words 
# Từ vựng xuất hiện trong phần câu hỏi của đề thi
ques_sample <- read.csv(here::here('output','ques_sample.csv'))   # ques_sample.csv được tạo trong 'word_frequency.R'

# Bắt đầu phần visualization

# num-vocabs
# Tổng số lượng từ vựng 
ggplot(combined_df, aes(x = source)) +
  
  geom_bar(fill = 'light blue', col = 'light blue', alpha = 0.5) +
  
  geom_text(
    stat = 'count',
    aes(label = ..count..),
    vjust = -0.5,
    family = 'serif',
    size = 2.7,
    color = ("dark red"),
    fontface = 'bold')+
  
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Tổng số từ vựng (từ vựng không lặp lại)',
    x = 'Tên sách',
    y = 'Số lượng từ') +
  
  theme_minimal() +
  
  theme(#grid elements
      axis.ticks = element_blank(),          #strip axis ticks
      axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
      axis.title.y = element_text(hjust = 1, face = 'bold'))


# num-words
# Tổng số lượng từ 
combined_df %>% 
  group_by(source) %>% 
  summarise(n = sum(freq)) %>% 
  
ggplot(aes(x = source, y = n)) +
  
  geom_bar(fill = 'light blue', col = 'light blue', alpha = 0.5, stat = 'identity') +
  
  geom_text(
    stat = 'identity',
    aes(label = n),
    vjust = -0.5,
    family = 'serif',
    size = 2.7,
    color = ("dark red"),
    fontface = 'bold')+
  
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Tổng số từ (từ vựng có lặp lại)',
    caption = 'Có bao gồm các từ thông dụng',
    x = 'Tên sách',
    y = 'Số lượng từ') +
  
  theme_minimal() +
  
  theme(
      axis.ticks = element_blank(),          #strip axis ticks
      axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
      axis.title.y = element_text(hjust = 1, face = 'bold'),
      plot.caption = element_text( hjust = 0))             #left align

 
# stopwords-normalwords
# Tỉ lệ từ vựng thông dụng vs từ vựng thông thường 
ggplot(combined_df, aes(x = word_type, group = source)) +
  
  geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat = 'count', alpha=0.5)+
  
  geom_text(
    #stat = 'freq',
    aes(label = scales::percent(..prop..),
        y = ..prop..), 
    stat = 'count',
    vjust = 1,
    family = 'serif',
    size = 2.7,
    color = 'black',
    fontface = 'bold') +
  
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Tỉ lệ từ thông thường vs từ thông dụng',
    #caption = 'Chú ý: Không bao gồm các từ thông dụng',
    #fill = 'Loại từ',
    y = 'Tỉ lệ',
    x = 'Loại từ') +
  
  facet_wrap(~source, nrow = 2)+
  
  scale_y_continuous(labels = scales::percent) +
  
  theme_minimal() +
  
  theme(legend.position = 'bottom',
        legend.title = element_text(face = 'bold'),
        axis.text.x = element_blank(),
        axis.ticks = element_blank(),          #strip axis ticks
      axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
      axis.title.y = element_text(hjust = 1, face = 'bold'),
      plot.caption = element_text( hjust = 0))+
  
  scale_fill_discrete(name = 'Loại từ',
                      labels = c('Thông thường', 'Thông dụng')) 

  
# data distribution
# Phân phối của dữ liệu
combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  group_by(source) %>% 
  ggplot(aes(x = freq)) +
  geom_histogram(binwidth = 1)+
  facet_wrap(~source, nrow = 3)+
  theme_minimal()+
  #xlim(c(0, 25)) 
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Phân phối của dữ liệu',
    caption = 'bin width = 1',
    y = 'Số lượng (lần)',
    x = 'Tần suất (lần)') +
  
  facet_wrap(~source, nrow = 3)+
  
  theme_minimal() +
  
  theme(legend.position = 'bottom',
        legend.title = element_text(face = 'bold'),
        axis.ticks = element_blank(),          #strip axis ticks
        axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
        axis.title.y = element_text(hjust = 1, face = 'bold'),
        plot.caption = element_text( hjust = 0))             #left align


# greater-25
# Từ vựng có tần suất xuất hiện từ 25 lần trở lên
combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  group_by(source) %>% 
  ggplot(aes(x = freq)) +
  geom_histogram(binwidth = 1)+
  facet_wrap(~source, nrow = 3)+
  theme_minimal()+
  xlim(c(25, 200)) +
  
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Phân phối của dữ liệu - tần suất từ 25 trở lên',
    caption = 'bin width = 1',
    y = 'Số lượng (lần)',
    x = 'Tần suất (lần)') +
  
  facet_wrap(~source, nrow = 3)+
  
  theme_minimal() +
  
  theme(legend.position = 'bottom',
        legend.title = element_text(face = 'bold'),
        axis.ticks = element_blank(),          #strip axis ticks
        axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
        axis.title.y = element_text(hjust = 1, face = 'bold'),
        plot.caption = element_text( hjust = 0))             #left align


# less-25
# Từ vựng có tần suất xuất hiện dưới 25 lần
combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  group_by(source) %>% 
  ggplot(aes(x = freq)) +
  geom_histogram(binwidth = 1)+
  facet_wrap(~source, nrow = 3)+
  theme_minimal()+
  xlim(c(0, 24)) +
  
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Phân phối của dữ liệu - tần suất dưới 25',
    caption = 'bin width = 1',
    y = 'Số lượng (lần)',
    x = 'Tần suất (lần)') +
  
  facet_wrap(~source, nrow = 3)+
  
  theme_minimal() +
  
  theme(
        axis.ticks = element_blank(),          #strip axis ticks
        axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
        axis.title.y = element_text(hjust = 1, face = 'bold'),
        plot.caption = element_text( hjust = 0))             #left align


# distribution-all
# Gộp chung từ vựng của 6 cuốn Cam. Lập histogram trên tập dữ liệu lớn này.
combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  plyr::ddply("word", plyr::numcolwise(sum)) %>% 
  ggplot(aes(x = freq)) +
  geom_histogram(binwidth = 1)+
  #facet_wrap(~source, nrow = 3)+
  theme_minimal()+
  #xlim(c(0, 23)) +
  
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Phân phối của dữ liệu (tổng từ vựng từ Cambridge 10  - 15)',
    caption = 'bin width = 1',
    y = 'Số lượng (lần)',
    x = 'Tần suất (lần)') +
  
  theme_minimal() +
  
  theme(legend.position = 'bottom',
        legend.title = element_text(face = 'bold'),
        axis.ticks = element_blank(),          #strip axis ticks
        axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
        axis.title.y = element_text(hjust = 1, face = 'bold'),
        plot.caption = element_text( hjust = 0))             #left align


# distribution-all-less-50
# Phấn phối từ vựng tập dữ liệu lớn - tần suất dưới 50

combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  plyr::ddply("word", plyr::numcolwise(sum)) %>% 
  ggplot(aes(x = freq)) +
  geom_histogram(binwidth = 1)+
  #facet_wrap(~source, nrow = 3)+
  theme_minimal()+
  xlim(c(0, 50)) +
  
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Phân phối của dữ liệu (tổng từ vựng từ Cambridge 10  - 15) - tần suất dưới 50',
    caption = 'bin width = 1',
    y = 'Số lượng (lần)',
    x = 'Tần suất (lần)') +
  
  #facet_wrap(~source, nrow = 3)+
  
  theme_minimal() +
  
  theme(legend.position = 'bottom',
        legend.title = element_text(face = 'bold'),
        axis.ticks = element_blank(),          #strip axis ticks
        axis.title.x = element_text(hjust = 1, vjust = 0, face = 'bold'),
        axis.title.y = element_text(hjust = 1, face = 'bold'),
        plot.caption = element_text( hjust = 0))             #left align


# words-normal-vs-common
x <- combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  plyr::ddply("word", plyr::numcolwise(sum)) %>% 
  filter(freq >= 24) %>% 
  summarise(n = sum(freq))

y <- combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  plyr::ddply("word", plyr::numcolwise(sum)) %>% 
  filter(freq < 24) %>% 
  summarise(m = sum(freq))
```

```{r}
value <- c(x[1,1], y[1,1])
word <- c('Tần suất từ 1 trở lên', 'Tần suất dưới 1')
piechart <- data.frame(word, value)

ggplot(piechart, aes(x ="", y = value, fill = word)) +
  geom_bar(width = 1, stat = 'identity')+
  geom_text(aes(label = paste(round(value / sum(value) * 100, 1), "%")),
            position = position_stack(vjust = 0.5)) +
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Tỉ lệ từ thông dụng vs từ thông thường') +
  theme_classic()+
  theme(plot.title = element_text(hjust = 0, vjust = 1),
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.title = element_blank(),
        axis.title = element_blank())+
  coord_polar("y", start = 0, direction = -1)
