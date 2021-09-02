library(tidytext)
library(dplyr)
library(here)
library(plyr)
library(data.table)
library(tidyr)

setwd("~/R project/textMining/ielts-vocab/data/cam10-15")
temp <- list.files(pattern = "*.txt")
myfiles <- lapply(temp, readLines)

# cleaning function
cleaning <- function(txt) {
  txt <- gsub('[0-9]+', '', txt) #remove number from text
  df <- as_tibble(txt)
  tidy <- df %>% 
    unnest_tokens(output = word, input = value) %>% 
    #filter(!word %in% stop_words$word) %>%
    count(word)
}

# Tìm các từ xuất hiện và số lần xuất hiện hiện
listofData <- list()

len_file <- length(myfiles)
for (i in 1:len_file) {
  txt <- myfiles[[i]]
  result <- cleaning(txt)
  nam <- paste("cam", i+9, sep = "")
  to_export <- assign(nam, result)
  listofData <- c(listofData, list(to_export))
}

# Loại bỏ các từ vô nghĩa (không phải tiếng Anh) và xuất file excel
len_listofData <- length(listofData)
for (i in 1:len_listofData) {
  a <- listofData[[i]]
  output <- a %>% 
    mutate(logi = hunspell::hunspell_check(a$word)==1) %>% # Dòng này để tạo ra một cột TRUE FALSE dựa trên kết quả của hunspell_check()
    filter(logi == 1) %>% 
    select(-logi) %>% 
    arrange(desc(freq))
  filename <- paste("camb", i+9, '.csv', sep = "")
  write.csv(output, here::here("output", filename), row.names = F)
}

# Các từ xuất hiện trong các câu hỏi của bài thi IELTS
dt <- readLines('ques_sample.txt')
output <- cleaning(dt) %>% 
  filter(!(word %in% stop_words$word))
write.csv(output, 'output/ques_sample.csv', row.names = F)
