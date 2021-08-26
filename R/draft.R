anim1 <- c(1456,2569,5489,1456,4587)
anim2 <- c(6531,6987,6987,15487,6531)
anim3 <- c(4587,6548,7894,3215,8542)
mydf <- data.frame(anim1,anim2,anim3)

str1 <- c("thảo", "kiên", "ảnh", "kỳ")
str2 <- c("thỏa", "hiền", "nam", "trang")
str3 <- c("thoa", "thánh", "thu", "thắng")
df2 <- data.frame(str1, str2, str3)

stack(mydf)

a <- as.vector(as.matrix(df2))
b <- as.vector(t(df2))

writeLines(a, "cmnr.csv", useBytes = T)

options(encoding = "utf-8")

iconv(a, "latin1", "UTF8")
Encoding(a)


for (word in a){
  if (Encoding(word) == "latin1"){
    Encoding(word) <- "utf-8"
  } else {
    print ("Lose")
  }
}


x <- rep("UTF-8", 12)
Encoding(a) <- x


str <- c("thảo", "ảnh", "kỳ", "kiên")
Encoding(str[4]) <- "latin1"
str
writeLines(str, "cm.txt", useBytes = F)
utf8::as_utf8(str)

x <- c("fa\u00E7ile", "fa\xE7ile", "fa\xC3\xA7ile")
Encoding(x) <- c("UTF-8", "UTF-8", "unknown")
# attempt to convert to UTF-8 (fails)
## Not run: 
utf8::as_utf8(x)
y <- x
Encoding(y[2]) <- "latin1" # mark the correct encoding
utf8::as_utf8(y) # succeeds
# test for valid UTF-8
utf8_valid(x)

writeLines(a, "cm.csv")
read_lines("cm.utf8", n = -1)
