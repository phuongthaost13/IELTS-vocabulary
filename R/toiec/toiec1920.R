library(dplyr)
library(tidytext)
library(tm)
library(data.table)
library(readr)
library(readxl)

# data input
# để có được các file 'toeicxxxx.txt' mình phải tìm bản pdf rồi dùng 
# công cụ trên mạng để chuyển pdf thành file txt. 
# Phát hiện ra là file pdf trên mạng sẽ có 2 dạng
# một là dạng chữ và dạng còn lại là các trang hình ảnh
# pdf dạng trang hình ảnh k thể chuyển thành file txt 
# nên chỉ tìm được đề toiec của 2019 và 2020.
# Lúc đầu mình chỉ định lọc ra các từ thường xuất hiện nhất trong các đề thi thử toeic
# Nhưng mà mình tình cờ thấy cuốn sách 600 từ toeic thông dụng, có cả dịch tiếng Việt
# nên mình thử so sánh từ mà mình lọc được trong các đề thi so với 600 từ của sách
# xem có trùng nhau hay, nếu trùng thì đỡ phải ngồi dịch từng từ bên file của mình lọc.
# Kết quả là chỉ trùng rất ít. 
# Nếu mục tiêu chỉ lên tầm TOEIC 450 thì không cần học cuốn 600 từ này.
# "toeic_words_translation.xlsx" là file sách 600 từ vựng TOEIC thông dụng 
# chuyền pdf thành txt, sau đó mình phải sử dụng excel để sắp xếp lại thành
# hai cột: từ vựng tiếng anh và bản dịch tiếng Việt.
# Bước sắp xếp này vì làm thủ công nên mệt vl.

toeic2019 <- read.delim("data/toeic2019.txt", header = F, quote = "") # Nếu k có 'quote=""' thì sẽ báo warning EOF within quoted string
toeic2020 <- read.delim("data/toeic2020.txt", header = F, quote = "")
vietnamese_translation <- readxl::read_xlsx("data/toeic_words_translation.xlsx", sheet = 1)

input <- rbind(toeic2019, toeic2020) 

# cleaning
data('stop_words')
input$V1 <- gsub('[0-9.]', '', input$V1) # Loại bỏ số ra khỏi văn bản
tidy <- input %>% 
  select(V1) %>% 
  unnest_tokens("word", V1) %>% 
  anti_join(stop_words) %>% 
  count(word) %>% 
  filter(n>10) %>% 
  arrange(desc(n)) %>% 
  left_join(vietnamese_translation %>% setNames(., tolower(names(.))), by = "word")
 # left_join(vietnamese_translation %>% mutate(word = tolower(word)), by = "word")
  

# các hàm của tidytext đã chuyển tất cả văn bản thành chữ thường nhưng 
# toeic_words_translation.xlsx chưa được thay đổi mà left_join lại không có ignore_case 
# nên mình phải dùng tolower()
# mutate() là để tạo thêm một cột mới, nhưng vì cột mới này trùng tên với cột cũ
# nên thực chất là tạo ra một cột y chang nhưng tất cả các chữ đề đã in thường.

# translation
# Từ kết quả trên thì mới lòi ra chuyện là mình muốn tìm cách làm sao có thể
# tự động dịch hết các từ mình mới lọc. Hơn 500 từ mà viết tay thì có chút
# có lỗi với việc học R. Mà hay cái, R nó có luôn công cụ để liên kết với 
# Google translate để dịch mới hay.
# Muốn xem thêm về phần này thì đọc ở "translation.R" trong cùng project này.

write.csv(tidy, here("output", "toeic1920.csv"))
setNames( 1:3, c("foo", "bar", "baz") )
