x <- as.data.frame("tôi là thảo")
a <- "熬夜工作 又睡不好"
b <-"tôi là thảo"

write.csv(x, "thao.csv", fileEncoding = "UTF-8")
writeLines("tôi là Thảo", "thao1.csv", useBytes = T)
Sys.getlocale()
bình thường nó có đọc đc k 
à không, đó là cái value
object nó mới đọc tiếng việt dc

ở dưới console thì đọc dc
nhưng bên value thì nó k hiện
hai đọc cái thảo mở này nha
có dùng cái write line đc k 
trong mấy cái file kia
ê

không được

nó k write object đc thôi, lấy data ra

à, để ông thử

test <- as.character(cm[,1])
writeLines(test, "thao1.csv", useBytes = T)

Được rồi.