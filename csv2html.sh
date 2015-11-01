#!/bin/bash

#En tête HTML
echo '<html lang="fr">'
echo '<head>'
echo '<meta charset="utf-8">'
echo '<title>Test Biere</title>'
echo '<link rel="stylesheet" href="style.css">'
echo '</head>'

#Compteur pour savoir si c'est la 1ére fois que l'on rentre dans la boucle
i=0

sep=';'
col=1
chaine='Nom'

#Boucle pour connaitre les arguments
for j in $@
do
    case ${j} in
	#Change le séparateur
	-d?)
	    sep=${j:2:1};
	    ;;
	#Trie par rapport à un numéro de colonne
	-s*)
	    col=${j:2};
	    ;;
	#Trie par rapport à un nom de colonne (ps: ça marche pas)
	-S*)
	    chaine=${j:2};
	    col=$(head -n 1 | tr ";" "\n" | grep $chaine -n | cut -d: -f1);
	    ;;
    esac
done

echo "<table>"

#Tant que l'on peux lire une ligne dans le fichier passé sur l'entrée standard
(head -n 1 && tail -n +3 | sort -t$sep -k$col) | while read ligne
do
    if ((i==0))
    then
	echo '<tr><th>'$ligne'</th></tr>' | sed s/$sep/'<\/th><th>'/g
	i=$i+1;
    else
	echo '<tr><td>'$ligne'</td></tr>' | sed s/$sep/'<\/td><td>'/g  
    fi
done
echo "</table>"

echo '</html>'
