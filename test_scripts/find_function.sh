#!/bin/bash

if [ -z "$1" ]
then
	echo "No arguments were given"
else
	for file in $(find . -name '*.c')
	do
		if [ "$(grep $1 $file)" ]
		then
			# echo 'potential match: '$file
			proto=$(cat $file | match_proto.sh "$1")
			if [ "$proto" ]
			then
				echo $file:
				echo "$proto"
			fi
		fi
	done
fi