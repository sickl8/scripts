#!/bin/bash

print_usage() {
    echo "$(basename -- $0): No argument supplied" >&2
    echo -e "\tUsage:\n\t\t$(basename -- $0) <function_name>" >&2
}

if [ -z "$1" ]
then
	print_usage
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