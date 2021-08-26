library(tidytext)
library(dplyr)
library(here)
library(plyr)
library(data.table)

setwd("~/R project/textMining/output/ielts")
temp <- list.files(pattern = "*.txt")
myfiles <- lapply(temp, read.delim)

tb <- as_tibble(rbindlist(myfiles))    #data.table package

# cleaning
data('stop_words')
df$i <- gsub('[0-9.]', '', df$i)
tidy <- tb %>% 
  select(i) %>% 
  unnest_tokens('word', i) %>% 
  anti_join(stop_words) %>% 
  count(var = 'word') %>% 
  filter(freq <= 10) %>% 
  arrange(desc(freq))

commonEngWords <- as_tibble(read.table(here::here("data", "mostCommonEnglishWords.txt"), header = F)) 
