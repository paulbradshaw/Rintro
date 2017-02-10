library(tm) ## text mining
library(stringr) ## text cleaning
library(wordcloud) ## word cloud
library(topicmodels) ## topic modelling
library(dplyr) #data wrangling
library(magrittr) # %>% piping
library(syuzhet) #sentiment analysis
library(lubridate) 
library(scales)
library(reshape2)


#read in data
data <- read.csv('Chime_Hack_Data.csv', stringsAsFactors = F)

#Change data type so it can be processed by NLP algs
Sys.setlocale('LC_ALL','C') ## - from http://r.789695.n4.nabble.com/Strings-from-different-locale-td3023176.html

#remove #tags, @s so Sentiment Analysis can read words
data$story_lower_case <- tolower(data$story)
data$story_lower_case <- str_replace_all(data$story_lower_case, "@", "")
data$story_lower_case <- str_replace_all(data$story_lower_case, "#", "")

mySentiment <- get_nrc_sentiment(data$story_lower_case)
head(mySentiment, 5)
data <- cbind(data, mySentiment)

##Other syuzhet methods - all work except for Standford
syuzhet_sent <- get_sentiment(data$story_lower_case, method = "syuzhet")
data <- cbind(data, syuzhet_sent)
bing_sent <- get_sentiment(data$story_lower_case, method = "bing")
data <- cbind(data, bing_sent)
afinn_sent <- get_sentiment(data$story_lower_case, method = "afinn")
data <- cbind(data, afinn_sent)
nrc_sent <- get_sentiment(data$story_lower_case, method = "nrc")
data <- cbind(data, nrc_sent)

##COUNTWORDS AND CHARCTERS PER STORY

data$charsinstory <- sapply(data$story, function(x) nchar(x))
data$wordsinstory <- sapply(strsplit(data$story, "\\s+"), length)

##get averages of Sentiment

sent_scores <- c(syuzhet_sent + bing_sent + afinn_sent + nrc_sent)
data <- mutate(data, sent_score_ave = sent_scores/4)
data <- mutate(data, sent_by_word = sent_score_ave/wordsinstory) 

##Additional variables

#1: Give person a unique number

data <- mutate(data,chime_id=as.numeric(factor(name)))

#2: Stem Stories so easier to search for key words highlighted by Topic Models

story_stem <- data$story

##Use TM to create another column with stem, punc, whitespace etc

story_stem <- str_replace_all(story_stem, "@\\w+", "")
story_stem <- stemDocument(story_stem)
story_stem <- removePunctuation(story_stem)
story_stem <- tolower(story_stem)
story_stem <- stripWhitespace(story_stem)
story_stem <- as.data.frame(story_stem)

data <- cbind(data, story_stem)

#4 Find instances of Hashtags and Create Separate Sheets

#Find instances of Hashtags

grepl("cheltjazz", data$story, ignore.case = TRUE) -> data$cheltjazz
grepl("jazzday", data$story, ignore.case = TRUE) -> data$jazzday

jazzday <- data %>%
  filter(jazzday == T)
chelt <- data %>%
  filter(cheltjazz == T)
jhive <- data %>%
  filter(source == 'jhive_posts')
remainder <- data %>%
  filter(jazzday == F, cheltjazz == F, source != 'jhive_posts')

write.csv(data, 'chime_data_sent.csv')
write.csv(jhive, 'jhive_posts.csv')
write.csv(chelt, 'cheltjazz_tweets.csv')
write.csv(jazzday, 'jazzday_tweets.csv')
write.csv(remainder, 'remainder_tweets.csv')
