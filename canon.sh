#!/bin/bash

if [ -z "$1" ]
then
	echo 'Usage: cmd <file_name without extension>'
else
	if [ -f "$1".cpp ] && [ -f "$1".hpp ]
	then
		canonhpp.sh "$1".hpp
		canoncpp.sh "$1".cpp
	else
		echo 'either files .cpp or .hpp does not exists for '"$1"
	fi
fi