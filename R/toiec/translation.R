library(translate)
library(translateR) 
library(here)

input <- read.csv("output/toeic1920.csv", header = T)
vietnamses_translation <- translate(input, 
                                    content.field = 'word', 
                                    google.api.key = 'YOUR-KEY-API',  # Điền key API của bạn vào đây
                                    source.lang = 'en',
                                    target.lang = 'vi')               # source.lang và target.lang lấy từ getGoogleLanguages()


write.csv(vietnamses_translation, "output/toeic_vietnamese.csv", row.names = F)

# Sau bước dịch, mình export data ra file toeic_vietnamese.csv thì thấy là
# chữ tiếng Việt bị viết ở dạng encoding, không đọc được.

# Sửa lỗi encoding
values <- as.character(vietnamses_translation[,1])
translatedContent <- as.character(vietnamses_translation[,2])
n <- as.character(vietnamses_translation[,3])

writeLines(values, "output/word.csv", useBytes = T)
writeLines(values, "output/translatedContent.csv", useBytes = T)
writeLines(values, "output/n.csv", useBytes = T)

# Ở đây, vì sử dụng API key cho để thực hiện việc dịch nên mình 
# tránh việc chạy dòng lệnh tạo object 'vietnamese_translation'
# nhiều lần. Sau khi tắt session thì object 'vietnamese_translation'
# cũng biến mất nên mình không nhớ rõ tên các cột. 
# Do đó, mình giả sử, tên ba cột theo thứ tự của dataframe lần lượt là
# values (từ tiếng Anh), translatedContent (từ được dịch), 
# n (số lần xuất hiện). 

# Hiện tại chưa biết lí do nhưng khi xuất một character vector
# thì lỗi font chữ không xảy ra. Do đó, mình lần lượt chuyển
# giá trị ở các cột của vietnamese_translation thành dạng character
# bằng hàm as.character() rồi sử dụng Writelines() để xuất ra
# các file csv riêng biệt và dùng cách thủ công để ghép các file
# này lại thành một bảng hoàn chỉnh gồm: từ tiếng anh, từ dịch và
# số lần xuất hiện.
