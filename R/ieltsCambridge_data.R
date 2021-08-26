library(tidyverse)
library(tesseract)
library(pdftools)
library(magick)

#pngfile <- pdf_convert("data/cam14.pdf", dpi = 150, pages = 2:88)
path <- dir(path = "~/R project/textMining/figs/cam14", pattern = "*.png", full.names = T)
imgs <- map(path, magick::image_read)
txt <- map(imgs, ocr)


write.table(txt, "output/ielts/cam14.txt")
