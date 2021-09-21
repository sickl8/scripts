#!/bin/bash

if [ -z "$1" ]
then
	echo fail
else
	cp ~/Desktop/templates/"$1" .
fi
