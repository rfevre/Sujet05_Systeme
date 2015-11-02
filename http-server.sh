#!/bin/bash

PATH=$(cd $(dirname $0) ; pwd):$PATH;
port=8080;
tube=/tmp/requete;

if [ ! -p $tube ]
then
    mkfifo $tube;
fi

while getopts p:d:t: option
do
    case $option in
	p)
	    port=$OPTARG;
	    echo "port : " $port;
	    ;;
	d)
	    export cheminRacine=$OPTARG;
	    echo "chemin Racine : " $cheminRacine;
	    ;;
	t)
	    export cheminModel=$OPTARG;
	    echo "chemin Model : " $cheminModel;
	    ;;
    esac
done

while true
do
    cat $tube | ./http-request.sh | nc -l -p $port > $tube
done
