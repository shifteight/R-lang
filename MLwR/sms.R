sms_raw <- read.csv('sms_spam.csv', stringsAsFactors=FALSE)
sms_raw$type <- factor(sms_raw$type)

require(tm)
sms_corpus <- Corpus(VectorSource(sms_raw$text))
corpus_clean <- tm_map(sms_corpus, content_transformer(tolower))
corpus_clean <- tm_map(corpus_clean, removeNumbers)
corpus_clean <- tm_map(corpus_clean, removeWords, stopwords())
corpus_clean <- tm_map(corpus_clean, removePunctuation)
corpus_clean <- tm_map(corpus_clean, stripWhitespace)
sms_dtm <- DocumentTermMatrix(corpus_clean)

# create training and test datasets

sms_raw_train <- sms_raw[1:4180, ]
sms_raw_test <- sms_raw[4181:5574, ]

sms_dtm_train <- sms_dtm[1:4180, ]
sms_dtm_test <- sms_dtm[4181:5574, ]

sms_corpus_train <- corpus_clean[1:4180]
sms_corpus_test <- corpus_clean[4181:5574]

# confirm that the subsets are representative
prop.table(table(sms_raw_train$type))
prop.table(table(sms_raw_test$type))

# create word cloud
require(wordcloud)
wordcloud(sms_corpus_train, min.freq=40, random.order=FALSE)

# comparing the clouds for spam and ham
spam <- subset(sms_raw_train, type=='spam')
ham <- subset(sms_raw_train, type=='ham')
## wordcloud function will do conversion automatically
wordcloud(spam$text, max.words=40, scale=c(3, 0.5))
wordcloud(ham$text, max.words=40, scale=c(3, 0.5))


