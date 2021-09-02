library(tidytext)
library(dplyr)
library(here)
library(plyr)
library(data.table)
library(tidyr)

setwd("~/R project/textMining/ielts-vocab/data")
temp <- list.files(pattern = "*.txt")
myfiles <- lapply(temp, read.delim)

# cleaning function
cleaning <- function(df) {
  data('stop_words')
  df$col <- gsub('[0-9.]', '', df$col)
  tidy <- df %>% 
    select(col) %>% 
    unnest_tokens('word', col) %>% 
    anti_join(stop_words) %>% 
    count('word') %>% 
    arrange(desc(freq))
}

listofData <- list()

len_file <- length(myfiles)
for (i in 1:len_file) {
  df <- as_tibble(myfiles[[i]])
  txt <- cleaning(df)
  nam <- paste("cam", i, sep = "")
  to_export <- assign(nam, txt)
  listofData <- c(listofData, list(to_export))
}
  
  
#df1 <- as_tibble(myfiles[[1]])
#tb <- as_tibble(rbindlist(myfiles))    #data.table package

#https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame

