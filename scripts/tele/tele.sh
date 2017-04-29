#!/bin/bash

cd /home/homeassistant/.homeassistant/scripts/tele/
declare -a chaines_tv=("tf1" "fr2" "fr3" "canal" "fr5" "m6" "arte" "c8" "w9" "tmc" "nt1" "nrj12" "lcp" "fr4")
taille_tableau=${#chaines_tv[@]}

#cd /home/gano/.homeassistant/www/tele/
rm index.html*
wget www.programme-television.org
cat index.html |gawk 'match($0, /<a .* title=\"(.*)\" class=\"\_NOL\">/, a) {print a[1]}' |sed s/"&#039;"/"'"/g > tele.list
cat index.html |gawk 'match($0, /<em>Programme (.*)/, a) {print a[1]}' |sed s/"&#039;"/"'"/g |sed -n 's,.*horaire\(.*\)\">,\1,p' |cut -d '<' -f 1|cut -d ">" -f 2 > horaire.txt
cat index.html |gawk 'match($0, /\"texte_cat\"><a href=\"(.*)\">/, a) {print a[1]}' |sed '2~2d' > categorie.txt

# on boucle sur les chaines
for (( i=1; i<${taille_tableau}+1; i++ ));
do
 head -$i tele.list |tail -1 > ${chaines_tv[$i-1]}
done

# on boucle sur les chaines
for (( i=1; i<${taille_tableau}+1; i++ ));
do
 heure=`head -${i} horaire.txt |tail -1`
 categorie=`head -${i} categorie.txt |tail -1`
 sed -e "s;$; - ${heure} (${categorie});" -i ${chaines_tv[$i-1]}
done
