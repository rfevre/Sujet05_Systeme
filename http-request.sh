#!/bin/bash

#On enregistre dans les variables correspondante les options
while getopts d:t: option
do
    case $option in
	d)
	    cheminRacine=$OPTARG;
	    #echo $cheminRacine;
	    ;;
	t)
	    cheminModel=$OPTARG;
	    #echo $cheminModel;
	    ;;
    esac
done

function notAllowed() {
    echo "HTTP/1.1 405 \"Method not allowed\"";
    #En-tete de reponse :
    echo "Content-type:text/html";
    echo "Content-Length:18";
    #Reponse : Erreur:
    echo -e "Method not allowed\r\n";
}

function notAcceptable() {
    #Ligne de statut : VERSION CODE PHRASE\r\n
    echo  "HTTP/1.1 406 \"Not Acceptable\"";
    #En-tete de reponse :
    echo "Content-type:text/html";
    echo "Content-Length:14";
    #Reponse : Nom de la ressource:
    echo -e "Not Acceptable\r\n";
}

function notFound() {
    #Ligne de statut : VERSION CODE PHRASE\r\n
    echo "HTTP/1.1 404 \"Not Found\"";
    #En-tete de reponse :
    echo "Content-type:text/html";
    echo "Content-Length:9";
    #Reponse : Nom de la ressource:
    echo -e "Not Found\r\n";
}

function itsOk() {
    echo "HTTP/1.1 200 OK";
    FILESIZE=$(stat -c%s "$1");
    
    #En-tete de reponse :
    echo "Content-type:text/html";
    echo "Content-Length:$FILESIZE";
}

function contenu() {
    #Si on trouve le fichier dans la racine on affiche son contenu
    if [ -f "$cheminRacine/$(echo "$url" | cut -d'/' -f3)" ]
    then
        itsOk "$cheminRacine/$(echo "$url" | cut -d'/' -f3)";
	cat "$cheminRacine/$(echo "$url" | cut -d'/' -f3)";
	echo -e "\r\n"
    else
        notAcceptable;
    fi
}

function html() {
    #Si on trouve le fichier dans la racine
    if [ -f "$cheminRacine/$(echo "$url" | cut -d'/' -f3)" ]
    then
	tmp="$cheminRacine/$(echo "$url" | cut -d'/' -f3)"; 

	#Si il est au format CSV
	if [ $(echo -e "$tmp" | tail -c5) == ".csv" ]
	then
	    itsOk "$tmp";
	    cat "$tmp" | ./csv2html.sh > "$(echo "$url" | cut -d'/' -f3 | cut -d'.' -f1).html";
	    echo -e "\r\n";
	    
        #Si il est au format txt
	elif [ "$(file -b -i "$tmp" | cut -d';' -f1)" == "text/plain" ]
	then
	    itsOk "$tmp";
	    ./remplace-dans.sh $cheminModel < $tmp > "$(echo "$url" | cut -d'/' -f3 | cut -d'.' -f1).html" ;
	    echo -e "\r\n";

	#Si il est dans un autre format
	else
	    notAcceptable;
	fi
	
    #Si on trouve le dossier dans la racine
    elif [ -d "$cheminRacine/$(echo "$url" | cut -d'/' -f3)" ]
    then
	echo "version HTML du contenu du dossier";

    #Si on ne trouve rien
    else
        notFound;
    fi
}

function verifRequete() {
    #Si l'url correspond à "contenu"
    if [ $(echo "$url" | cut -d'/' -f2) == "contenu" ]
    then
	contenu;
    #Si l'url correspond à "html"    
    elif [ $(echo "$url" | cut -d'/' -f2) == "html" ]
    then
	html;
    #Si ça correspond à rien
    else
	notAcceptable;
    fi
}

url="";

while [ "$url" != "exit" ]
do
    #On enregistre la 1ere ligne de la requete
    read method url version;
    read line;
    #Tant que la ligne n'est pas vide on lis la requête
    while [ -n "$line" ]
    do
	read line;
    done

    #Si la méthode correspond bien à "GET"
    if [ "$method" == "GET" ]
    then
	verifRequete;
    #Si ce n'est pas la méthode "GET"
    else
	notAllowed;
    fi
done





