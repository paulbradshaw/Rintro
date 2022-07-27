# Analysing reports of investigations into police using word frequency, ngrams and topic modeling

We've scraped IOPC recommendation reports. Now we want to analyse them. Below I detail code for extracting ngrams (phrases) and topic modeling.

Most of this code is adapted from [Text Mining with R: A Tidy Approach](https://www.tidytextmining.com/tidytext.html)

## Import the data and libraries

Import the data - make sure that strings aren't imported as factors:

```{r import summaries and recommendations}
summaries <- read.csv("scrapedsummaries.csv", stringsAsFactors = F)
recs <- read.csv("scrapedrecommendations.csv", stringsAsFactors = F)
```

Import the libraries:

```{r import libraries}
library(dplyr)
library(tidytext)
library(tidyr)
library(janeaustenr)
```

## Counting the most common words

To analyse the text we need to convert the column containing it into a data frame:

```{r convert recs to tibble}
#Remove empty entries
recsnotempty <- subset(recs,recs$recommendation != "")
#We specify a range of numbers for the line column
recs_df <- tibble(line = 1:220, text = recsnotempty$recommendation)
```

We then **tokenise** - splitting every word into its own row. 

The column must be text, [not factors](https://stackoverflow.com/questions/57465241/error-in-check-inputx-input-must-be-a-character-vector-of-any-length-or-a-li) so make sure that `stringsAsFactors` is set to `True` when importing the data above.

Punctuation is stripped when doing this, and by default text is converted to lowercase (set `to_lower = FALSE` if you want to prevent this happening).

```{r tokenise}
#for recommendations
#"break the text into individual tokens (a process called tokenization) and transform it to a tidy data structure"
#https://www.tidytextmining.com/tidytext.html
tokenisedrecs <- recs_df %>%
  unnest_tokens(word, text) #word is the name of the column, text is the column we are using

#for summaries
summaries_df <- tibble(line = 1:1284, text = recs$content)
tokenisedsummaries <- summaries_df %>%
  unnest_tokens(word, text) #word is the name of the column, text is the column we are using
```

We can also remove stop words like 'and' using tidytext package's `stop_words` dataset.

```{r remove stop words}
#load stop words
data(stop_words)
#remove them from tokenisedrecs
tokenisedrecs <- tokenisedrecs %>%
  anti_join(stop_words)

#for summaries
tokenisedsummaries <- tokenisedsummaries %>%
  anti_join(stop_words)
```

Then identify the most common words:

```{r count freq}
recwordfreq <- tokenisedrecs %>%
  count(word, sort = TRUE) 
recwordfreq
write.csv(recwordfreq,"recwordfreqnostopwords.csv")

#for summaries
sumwordfreq <- tokenisedsummaries %>%
  count(word, sort = TRUE) 
sumwordfreq
write.csv(sumwordfreq,"sumwordfreq.csv")
```

## Ngrams and bigrams and trigrams

What if we want to look at phrases rather than individual words? We can extract ngrams (multiple words - the 'n' meaning 'number of') - below we extract bigrams (2 word ngrams):

```{r extract bigrams}
#"break the text into individual tokens (a process called tokenization) and transform it to a tidy data structure"
#https://www.tidytextmining.com/tidytext.html
tokenisedrecsngram2 <- recs_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) 
tokenisedrecsngram2

#for summaries
tokenisedsumsngram2 <- summaries_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) 
tokenisedsumsngram2
```

Then count the most frequent:

```{r count bigrams}
bigramcount <- tokenisedrecsngram2 %>%
  count(bigram, sort = TRUE)
bigramcount

#for summaries
summariesbigramcount <- tokenisedsumsngram2 %>%
  count(bigram, sort = TRUE)
summariesbigramcount
```

Now remove the stop words:

```{r remove stop words export bigrams}
#separate bigrams into each word - code adapted from https://www.tidytextmining.com/ngrams.html
bigrams_separated <- tokenisedrecsngram2 %>%
  tidyr::separate(bigram, c("word1", "word2"), sep = " ")
#show result
bigrams_separated
#filter out stop words
bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)
# new bigram counts:
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)
#show
bigram_counts
#export
write.csv(bigram_counts,"recsbigram_counts.csv")

#recombine
bigrams_united <- bigrams_filtered %>%
  tidyr::unite(bigram, word1, word2, sep = " ")
```

And for summaries

```{r remove stop words export bigrams for summaries}
#separate bigrams into each word - code adapted from https://www.tidytextmining.com/ngrams.html
bigrams_separatedSUM <- tokenisedsumsngram2 %>%
  tidyr::separate(bigram, c("word1", "word2"), sep = " ")
#show result
bigrams_separatedSUM
#filter out stop words
bigrams_filteredSUM <- bigrams_separatedSUM %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)
# new bigram counts:
bigram_countsSUM <- bigrams_filteredSUM %>% 
  count(word1, word2, sort = TRUE)
#show
bigram_countsSUM
#export
write.csv(bigram_countsSUM,"sumsbigram_counts.csv")

#recombine
bigrams_unitedSUM <- bigrams_filteredSUM %>%
  tidyr::unite(bigram, word1, word2, sep = " ")


```

Try trigrams:

```{r extract trigrams}
#"break the text into individual tokens (a process called tokenization) and transform it to a tidy data structure"
#https://www.tidytextmining.com/tidytext.html
tokenisedrecsngram3 <- recs_df %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) 
tokenisedrecsngram3

trigramcount <- tokenisedrecsngram3 %>%
  count(trigram, sort = TRUE)
trigramcount

trigrams_separated <- tokenisedrecsngram3 %>%
  tidyr::separate(trigram, c("word1", "word2", "word3"), sep = " ")
#show result
trigrams_separated

#filter out stop words
trigrams_filtered <- trigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word3 %in% stop_words$word)
# new trigram counts:
trigram_counts <- trigrams_filtered %>% 
  count(word1, word2, word3, sort = TRUE)
#show
trigram_counts
#export
write.csv(trigram_counts,"recstrigram_counts.csv")

#recombine
trigrams_united <- trigrams_filtered %>%
  tidyr::unite(trigram, word1, word2, word3, sep = " ")

```

## Topic modelling 

Experimentally, we can try some topic modelling to see if we can identify clusters of reports which may share particular qualities. In other words, organise reports by features that they share that would otherwise be hard to identify.

```{r}
#from https://www.tidytextmining.com/topicmodeling.html
#first we need to install a package
install.packages("topicmodels")
library(topicmodels)
#Without this line we get an error about no tm package being loaded
install.packages("tm")
library(ggplot2)

#simplify our dataframe to just indexes and text
summariesonly <- summaries[,c(1,5)]
# split into words
by_summary_word <- summariesonly %>%
  unnest_tokens(word, content)

#create some extra words to remove
custom_stop_words <- bind_rows(tibble(word = c("police","officer","officers"),  
                                      lexicon = c("custom","custom","custom")), 
                               stop_words)
# find report-word counts
word_counts <- by_summary_word %>%
  anti_join(custom_stop_words) %>%
  count(X, word, sort = TRUE) %>%
  ungroup()

word_counts


#code adapted from https://www.tidytextmining.com/topicmodeling.html
summaries_dtm <- word_counts %>%
  tidytext::cast_dtm(X, word, n)

#> A LDA_VEM topic model with 4 topics.
summaries_lda <- LDA(summaries_dtm, k = 7, control = list(seed = 1234))
summaries_lda

summaries_topics <- tidy(summaries_lda, matrix = "beta")
summaries_topics

top_terms <- summaries_topics %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()
```


