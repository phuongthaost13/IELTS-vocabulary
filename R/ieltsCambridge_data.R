library(tidyverse)
library(tesseract)
library(pdftools)
library(magick)
library(here)
library(dplyr)

#pngfile <- pdf_convert(here::here("backUp", "pdf", "cam14.pdf"), dpi = 450, pages = 2:88)
path <- dir(path = "C:\\Users\\KimLoai\\Documents\\R project\\textMining\\ielts-vocab\\figs\\camx14", pattern = "*.png", full.names = T)
#imgs <- map(path, magick::image_read)
txt <- map(imgs, ocr)

write.table(txt, here::here("output", "cam10-15", "camx14.txt"))

# Sau tất cả nhưng việc làm kể trên thì file txt xuất ra phát
# hiện nhiều lỗi. Đại khái là mình phải sử dụng gsub() để
# loại bỏ hết mấy cái dấu câu ra.

setwd("~/R project/textMining/ielts-vocab/data/cam10-15")
temp <- list.files(pattern = "*.txt")
myFiles <- lapply(temp, readLines)

remove_Punc <- function(txt) {
  rm <- gsub(".n", " ", txt, fixed = T)
  rm <- gsub(".", " ", rm, fixed = T)
  rm <- gsub("__", " ", rm, fixed = T)
  rm <- gsub("\n", " ", rm, fixed = T)
  rm <- gsub('[0-9.]', "", rm)
  rm <- gsub('_', "", rm, fixed = T)
}

setwd("~/R project/textMining/ielts-vocab/data")

len_myFiles <- length(myFiles)
for (i in 1:len_myFiles) {
  txt <- myFiles[[i]]
  output <- remove_Punc(txt)
  writeLines(output, paste("cam", i+9, ".txt", sep = ""))
}
