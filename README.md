# R-Sentimental-Analysis
用 R 語言進行情感分析

## 範例文章來源網址
[Netflix announces multi-year production deal with the Obamas](http://money.cnn.com/2018/05/21/media/barack-michelle-obama-netflix-deal/index.html)

## 安裝套件
install.packages("rvest")
install.packages("dplyr")
install.packages("tidytext")
install.packages("tidyr")
install.packages("ggplot2")

## 輸出範例
![範例圖片](https://github.com/telunyang/R-Sentiment-Analysis/blob/master/Rplot.png)

## 基礎程式碼
```
library(rvest)
library(dplyr)
library(tidytext)
library(tidyr)
library(ggplot2)

# 欲抓取的網址
url <- "http://money.cnn.com/2018/05/21/media/barack-michelle-obama-netflix-deal/index.html"

# 建立空字串
str_text <- as.character()

# 讀取網頁 html 元素
webpage <- read_html(url)

# 找出合適的段落
h2 <- html_nodes(webpage, 'h2.speakable')
div <- html_nodes(webpage, 'div#storytext p')

# 把 h2 的部分先加到初始化的向量中
v_text <- c(html_text(h2))

# 加入其它段落的文字到向量中
for(p in div){
  v_text <- append(v_text, html_text(p))
}

# 文件編號
v_docId <- c()
for(x in 1:length(v_text)){
  v_docId <- append(v_docId, x)
}

# 轉換列數與段落文字，成為 dataframe 物件
text_df <- data_frame(doc_id = v_docId, text = v_text)

text_df

# 將原先的句子拆成單詞
tidy_script <- text_df %>% 
  unnest_tokens(word, text)

tidy_script

# [調用加拿大國家研究委員會的情緒詞典]
# 每個文件中的每個字，各代表的情感為何
tidy_script %>% 
  inner_join(get_sentiments("nrc")) %>% 
  arrange(doc_id) %>% 
  head(100)

# [調用加拿大國家研究委員會的情緒詞典]
# 每個文件中，各種情感的數量為何
tidy_script %>% 
  inner_join(get_sentiments("nrc")) %>% 
  count(doc_id, sentiment) %>% 
  arrange(doc_id) %>% 
  head(100)

# [調用加拿大國家研究委員會的情緒詞典]
# 用index區分，分成段落，%/% 代表整除符號，
# 這樣 0-4 行成了第一段落，5-9行成為第二段落
tidy_script %>% 
  inner_join(get_sentiments("nrc")) %>% 
  count(doc_id, sentiment) %>% 
  mutate(index = doc_id %/% 5) %>% 
  arrange(index) %>% 
  head(100)

# 繪製圖片
tidy_script %>% 
  inner_join(get_sentiments("nrc")) %>% 
  count(doc_id, sentiment) %>% 
  mutate(index = doc_id %/% 5) %>% 
  ggplot(aes(x=index, y=n, color=sentiment)) %>% + geom_col()

# 繪製圖片
tidy_script %>% 
  inner_join(get_sentiments("nrc")) %>% 
  count(doc_id, sentiment) %>% 
  mutate(index = doc_id %/% 5) %>% 
  ggplot(aes(x=index, y=n, color=sentiment)) %>% + geom_col() %>% 
  + facet_wrap(~sentiment, ncol=3)
```