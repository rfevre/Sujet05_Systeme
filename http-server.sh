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
	    echo $port;
	    ;;
	d)
	    cheminRacine=$OPTARG;
	    echo $cheminRacine;
	    ;;
	t)
	    cheminModel=$OPTARG;
	    echo $cheminModel;
	    ;;
    esac
done

while true
do
    cat $tube | ./http-request.sh -d $cheminRacine -t $cheminModel  | nc -l -p $port > $tube
done
