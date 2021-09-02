library(ggplot2)
library(scales)
library(hrbrthemes)
library(tidytext)


# num-words-no-rep
# Tổng số lượng từ (từ không lặp lặp lại)

ggplot(combined_df, aes(x = source)) +
  
  geom_bar(fill = '#041e42') +
  
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
    subtitle = 'Tổng số lượng từ (từ không lặp lại)',
    x = 'Tên sách',
    y = 'Số lượng từ') +
  
  theme_ipsum() 

# num-words-with-rep
# Tổng số lượng từ (từ có lặp lặp lại)
combined_df %>% 
  group_by(source) %>% 
  summarise(n = sum(freq)) %>% 
  
ggplot(aes(x = source, y = n)) +
  
  geom_bar(fill = '#041e42', stat = 'identity') +
  
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
    subtitle = 'Tổng số lượng từ (từ có lặp lại)',
    x = 'Tên sách',
    y = 'Số lượng từ') +
  
  theme_ipsum() 
 

# Tỉ lệ từ thông dụng vs từ thông thường (từ không lặp lại)

ggplot(combined_df, aes(x = word_type, group = source)) +
  
  geom_bar(aes(y = ..prop.., fill = factor(..x..)), stat = 'count') +
  
  geom_text(
    #stat = 'freq',
    aes(label = scales::percent(..prop..),
        y = ..prop..), 
    stat = 'count',
    vjust = -0.5,
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
  
  theme_ipsum() +
  
  theme(legend.position = 'bottom',
        legend.title = element_text(face = 'bold'),
        axis.text.x = element_blank())+
  
  scale_fill_discrete(name = 'Loại từ',
                      labels = c('Thông thường', 'Thông dụng')) 
  
# Cheking normalarity of data
combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  #filter(freq > 25) %>% 
  ggplot(aes(x = freq)) +
  geom_histogram(binwidth = 1, fill='#041e42', color="#e9ecef", alpha=0.9)+
  labs(
    title = 'Từ vựng sách Cambridge English IELTS 10 - 15',
    subtitle = 'Kiểm tra phân phối',
    x = 'Tần suất xuất hiện (lần)',
    y = 'Số lượng (lần)')+
  #ggtitle('Kiểm tra phân phối')+
  theme_ipsum() +
  xlim(c(0,100))

# Checking normalarity of data (seperate for each book)
combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  group_by(source) %>% 
  ggplot(aes(x = freq)) +
  geom_histogram(binwidth = 1)+
  facet_wrap(~source, nrow = 3)+
  theme_ipsum()+
  xlim(c(0, 25))
