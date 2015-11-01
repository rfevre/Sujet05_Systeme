#!/bin/bash

#script qui remplace une partie du model (paramètre) par un corps (entrée stantard)
read corps;

echo `cat $1` | sed -n '1h;1!H;${;g;s/<!-- DEBUT -->'.*'<!-- FIN -->/'"$corps"'/g;p;}';
