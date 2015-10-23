#!/bin/bash

function verifGet {
    echo 'ok'
    parametre=`echo $line | cut -d/ -f2`;
    if [ $parametre == 'contenu' ]
    then
	echo 'contenu';

    elif [ $parametre == 'html' ]
    then
	echo 'html';
 
    else
	echo 'error';
    fi
    
}

read line;

get=`echo $line | cut -d' ' -f1`;

# Si $get n'est pas vide
if [[ ! -z $get ]]
then
    if [ $get == 'GET' ]
    then
	verifGet;
    else
	echo '(HTTP/1.0,405,"Method Not Allowed")';
    fi
fi

#echo $line
