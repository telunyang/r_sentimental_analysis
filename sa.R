library(rvest)
library(dplyr)
library(tidytext)
library(tidyr)
library(ggplot2)

# 欲抓取的網址
url <- "http://money.cnn.com/2018/05/21/media/royal-wedding-ratings/index.html"

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

# 將原先的句子拆成單詞
tidy_script <- text_df %>% 
  unnest_tokens(word, text)

# 調用加拿大國家研究委員會的情緒詞典(每個文件中的每個字，各代表的情感為何)
tidy_script %>% 
  inner_join(get_sentiments("nrc")) %>% 
  arrange(doc_id) %>% 
  head(10)

# 調用加拿大國家研究委員會的情緒詞典(每個文件中，各種情感的數量為何)
tidy_script %>% 
  inner_join(get_sentiments("nrc")) %>% 
  count(doc_id, sentiment) %>% 
  arrange(doc_id) %>% 
  head(10)