library(data.table)
library(dplyr)
library(tidytext)

# data import
setwd("~/R project/textMining/ielts-vocab/output/cam10-15")
temp <- list.files(pattern = "*.csv")
myFiles <- lapply(temp, read.csv)


len_myFiles <- length(myFiles)
for (i in 1:len_myFiles) {
  myFiles[[i]]$source <- paste("Cambridge", i+9)
}

# combine all dataframe into one
combined_df <- bind_rows(myFiles)
len_cd <- nrow(combined_df)
for (i in 1:len_cd) {
  if (combined_df$word[i] %in% stop_words$word) {
  combined_df$word_type[i] = 'sw'
} else {
  combined_df$word_type[i] = 'nm'
}
}

# words that appear in all books without stopwords
allAppeared <- myFiles %>% 
  reduce(inner_join, by = "word") %>% 
  filter(!(word %in% stop_words$word)) %>% 
  setnames(new = paste('Cambridge', 10:15, sep = " "),
           old = colnames(allAppeared[2:7]))

# question sample words 
ques_sample <- read.csv(here::here('output','ques_sample.csv'))

# distribution-all
a <- combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  plyr::ddply("word",plyr::numcolwise(sum)) %>% 
  filter(freq < 24)

b <- combined_df %>% 
  filter(!(word %in% stop_words$word)) %>%
  filter(!(word %in% ques_sample$word)) %>% 
  plyr::ddply("word",plyr::numcolwise(sum)) %>% 
  filter(freq >= 24)


t <- combined_df %>% 
  distinct(word) %>% 
  filter(!(word %in% stop_words$word)) #%>% 
  summarise(n = sum(freq))

z <- ques_sample %>% 
  filter(!(word %in% stop_words$word)) %>% 
  nrow()
  
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
  nrow()
   
# Tổng số từ vựng: t = 8703  
#- freq >= 1: x = 764
#- freq < 1: y = 7889
#- ques_sample: z = 51
# stopwords = 1149
