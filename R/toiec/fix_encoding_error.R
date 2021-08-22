library(dplyr)
library(tidyr)
library(here)

trans_vn <- read.table("data/cho.utf8",
                       sep=",",
                       header=FALSE, 
                       encoding="vietnamese", 
                       stringsAsFactors=FALSE,
                       fill = T)

trans_utf8 <- read.table("data/cho.utf8",
                         sep=",",
                         header=FALSE, 
                         encoding="UTF-8", 
                         stringsAsFactors=FALSE,
                         fill = T)

dt1 <- as.data.frame(t(trans_utf8)) 

a <- data.frame(x=unlist(dt1))

vi <- as.character(a[,1])
writeLines(vi, "output/vi.csv", useBytes = T)

# Word
word_utf8 <- read.table("data/word.utf8", header = F, 
                        sep = ",", fill = TRUE, encoding = 'UTF-8',
                        quote = "",
                        stringsAsFactors = F,
                        row.names = NULL)

dt2 <- as.data.frame(t(word_utf8)) 


b <- data.frame(x=unlist(dt2))

en <- as.character(b[,1])
writeLines(en, "output/en.csv", useBytes = T)

# frequency
frequency_utf8 <- read.table("data/n.utf8", header = F, 
                             sep = ",", fill = TRUE, encoding = 'UTF-8',
                             quote = "",
                             stringsAsFactors = F,
                             row.names = NULL)

dt3 <- as.data.frame((t(frequency_utf8)))

c <- data.frame(x=unlist(dt3))

n <- as.character(c[,1])
writeLines(n, "output/n.csv", useBytes = T)
