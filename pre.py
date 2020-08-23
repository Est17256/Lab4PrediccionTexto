import re
from nltk.corpus import stopwords
import nltk
import random
import numpy as np
import pandas as pd
from collections import Counter, defaultdict
# nltk.download('all')
stopwords=set(stopwords.words('english'))
############################################Carga de datos############################################
f = open('./en_US.blogs.txt', 'r',encoding="utf-8")
blogs = f.readlines()
f.close()
f = open('./en_US.twitter.txt', 'r',encoding="utf-8")
tweets = f.readlines()
f.close()
f = open('./en_US.news.txt', 'r',encoding="utf-8")
news = f.readlines()
f.close()
print("Carga terminada")
############################################Se pasa a mayusculas############################################
blogs2=[]
for i in blogs:
    blogs2.append(i.upper())
tweets2=[]
for i in tweets:
    tweets2.append(i.upper())
news2=[]
for i in news:
    news2.append(i.upper())
print("Mayus terminada")
############################################Carga de datos############################################
blogs3=[]
for i in blogs2:
    blogs3.append(re.sub('\w+:\/{2}[\d\w-]+(\.[\d\w-]+)*(?:(?:\/[^\s/]*))*','',i))
tweets3=[]
for i in tweets2:
    tweets3.append(re.sub('\w+:\/{2}[\d\w-]+(\.[\d\w-]+)*(?:(?:\/[^\s/]*))*','',i))
news3=[]
for i in news2:
    news3.append(re.sub('\w+:\/{2}[\d\w-]+(\.[\d\w-]+)*(?:(?:\/[^\s/]*))*','',i))
print("URL terminada")
############################################Se eliminan caracteres especiales############################################
blogs4=[]
for i in blogs3:
    blogs4.append(re.sub('[^a-zA-Z0-9 ]+','', i))
tweets4=[]
for i in tweets3:
    tweets4.append(re.sub('[^a-zA-Z0-9 ]+','', i))
news4=[]
for i in news3:
    news4.append(re.sub('[^a-zA-Z0-9 ]+','', i))
print("Limpia terminada")
############################################Eliminacion de stopwords############################################
# stopwords=set(stopwords.words('english'))
blogs5=[]
for i in blogs4:
    blogL=[]
    for j in i.split():
        if j not in stopwords:
            blogL.append(j)
    blogs5.append(' '.join(blogL))
tweets5=[]
for i in tweets4:
    tweetL=[]
    for j in i.split():
        if j not in stopwords:
            tweetL.append(j)
    tweets5.append(' '.join(tweetL))
news5=[]
for i in news4:
    newL=[]
    for j in i.split():
        if j not in stopwords:
            newL.append(j)
    news5.append(' '.join(newL))
print("Stopwords terminada")
############################################Trigrama Limpio############################################
def calc_3gram(data):
    
    n_gram = []
    
    for tmp_data in data:
        last = ""
        p_last = ""
        for wn in tmp_data.split():
            if p_last == "":
                p_last = wn
                continue
            elif last == "":
                last = p_last
                p_last = wn
                continue
                
            n_gram.append((last, p_last, wn))
            last = p_last
            p_last = wn

    return n_gram

AllData = tweets5 + news5 + blogs5
porcentage = 0.5
length = len(AllData)
cut = int(length*porcentage)

subsection = AllData[:cut]
n3_gram = calc_3gram(subsection)
print("Trigrama terminado")
############################################Probabilidad de ocurrencia############################################
prob = defaultdict(lambda: defaultdict(lambda: 0))
for i,j,k in n3_gram:
    prob[(i,j)][k] +=1
for i,j in prob:
    proT=float(sum(prob[(i,j)].values()))
    for k in prob[(i,j)]:
        prob[(i,j)][k] /= proT    
print(dict(prob))
