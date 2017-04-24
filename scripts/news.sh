#!/bin/sh
cd /home/homeassistant/.homeassistant/scripts/
rm news.html
wget http://www.bfmtv.com/rss/info/flux-rss/flux-toutes-les-actualites/
mv index.html news.html
grep title news.html > news_temp.html
head -23 news_temp.html > news_temp2.html
mv news_temp2.html news_temp.html
#sed -n '20p' news.html > news_temp.html
a=`cat news_temp.html| cut -d "<" -f 3|cut -d '[' -f 3`
echo $a > news.txt
sed -i -e "s/]]>/\n/g" news.txt
sed -i -e "s/[^>]*>//g" news.txt
cat news.txt|sed 's/$/ NewDelim/' | tr '\n' ' ,' > news2.txt
sed -i -e "s/NewDelim/, /g" news2.txt
mv news2.txt news.txt
sed -i -e "s/\"//g" news.txt
sed -i -e "s/“//g" news.txt
sed -i -e "s/”//g" news.txt
