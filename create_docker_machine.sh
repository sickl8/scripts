#!/bin/bash

if [ $1 ] && [ $2 ]
then
	docker-machine create $1 --driver virtualbox --virtualbox-memory 4096 --virtualbox-disk-size 50000 --virtualbox-hostonly-cidr "$2"
else
	echo "Usage: $> ./script MACHINE_NAME CIDR_IP"
fi
