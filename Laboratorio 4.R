
install.packages("readtext")
install.packages("tm")
install.packages("qdap")
install.packages("wordcloud")
install.packages("RWeka")

library(readtext)
library(tm)
library(qdap)
library(wordcloud)
library(ggplot2)
library(RWeka)

setwd("C:/Users/jcmen/Desktop/DataScience/Lab4/txt")  # directorio de trabajo

#Cargar los archivos
blogs <- readLines("C:/Users/jcmen/Desktop/DataScience/Lab4/txt/en_US.blogs.txt")
news <- readLines("C:/Users/jcmen/Desktop/DataScience/Lab4/txt/en_US.news.txt")
twitter <- readLines("C:/Users/jcmen/Desktop/DataScience/Lab4/txt/en_US.twitter.txt")

#Tamaño del archivo
round(file.info("C:/Users/jcmen/Desktop/DataScience/Lab4/txt/en_US.blogs.txt")$size/1024^2, 1)
# conteo de líneas
length(blogs)
#Recuento de palabras
sum(sapply(strsplit(blogs, "\\s+"), length))
# Media de las palabras*línea
mean(sapply(strsplit(blogs, "\\s+"), length))

#Tamaño del archivo
round(file.info("C:/Users/jcmen/Desktop/DataScience/Lab4/txt/en_US.news.txt")$size/1024^2, 1)
# conteo de lineas
length(news)
#Recuento de palabras
sum(sapply(strsplit(news, "\\s+"), length))
# Media de las palabras*línea
mean(sapply(strsplit(news, "\\s+"), length))


#Tamaño del archivo
round(file.info("C:/Users/jcmen/Desktop/DataScience/Lab4/txt/en_US.twitter.txt")$size/1024^2, 1)
# Conteo de líneas
length(twitter)
#Recuento de palabras
sum(sapply(strsplit(twitter, "\\s+"), length))
# Media de las palabras*línea
mean(sapply(strsplit(twitter, "\\s+"), length))


#se crea el corpus
set.seed(1)
repdata <- c(sample(blogs, size = 0.005*length(blogs)), sample(news, size = 0.005*length(news)), sample(twitter, size = 0.005*length(twitter)))
rm(blogs, news, twitter)

#limpiar datos 
corpus <- VCorpus(VectorSource(repdata))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, content_transformer(tolower))


#frecuencia de palabras 
uniGramTokenizer <- function(x)NGramTokenizer(x, Weka_control(min = 1, max = 1))
biGramTokenizer <- function(x)NGramTokenizer(x, Weka_control(min = 2, max = 2))

uniGramMatrix <- TermDocumentMatrix(corpus, control = list(tokenize = uniGramTokenizer))
biGramMatrix <- TermDocumentMatrix(corpus, control = list(tokenize = biGramTokenizer))

#Unigrama
freqTerms <- findFreqTerms(uniGramMatrix, lowfreq = 500)
termFrequency <- rowSums(as.matrix(uniGramMatrix[freqTerms,]))
termFrequency <- data.frame(unigram=names(termFrequency), frequency=termFrequency)

#gráfica de la frecuencia de una sola palabra
ggplot(termFrequency[1:30,], aes(x=reorder(unigram, -frequency), y=frequency)) +
  labs(x = "Unigramas", y = "Frecuencia", title = "Frecuencia de Unigramas") +
  theme(axis.text.x = element_text(angle = 60, size = 12, hjust = 1)) +
  geom_bar(stat = "identity", fill = "56E709")

#Bigrama
freqTerms <- findFreqTerms(biGramMatrix, lowfreq = 10)
termFrequency <- rowSums(as.matrix(biGramMatrix[freqTerms,]))
termFrequency <- data.frame(bigram=names(termFrequency), frequency=termFrequency)

#Gráfica de la frecuencia de dos palabras
ggplot(termFrequency[1:30,], aes(x=reorder(bigram, -frequency), y=frequency)) +
  labs(x = "Bigramas", y = "Frecuencia", title = "Frecuecia de bigramas") +
  theme(axis.text.x = element_text(angle = 60, size = 12, hjust = 1)) +
  geom_bar(stat = "identity", fill = "#FF3D13")


