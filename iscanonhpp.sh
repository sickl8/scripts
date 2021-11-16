#!/bin/bash
function d8() {
	date +%H:%M:%S\ %d/%m/%y
}
class="$(cat $1 | regex.py 'class[^\S\n\r]+([_a-zA-Z][0-9a-zA-Z]*)')"
tmp=/tmp/tmpfile
tmp2=/tmp/tmpfile2
tab="$(cat $1 | regex.py '^([^\S\n\r]+)[^\n]*' - 0 | awk ' { if ( length > x ) { x = length; y = $0 } }END{ print y }')"
cat "$1" > $tmp
function check() {
	str="$(cat "$1" | regex.py "$2")"
	# echo "---------------------"
	if [ -z "$str" ];
	then
		echo -e -n '\033[31;1m'
		echo "$1 is not canonical"
		echo -e -n '\033[0m'
		exit
	# else
	# 	echo "not an empty string"
	fi
}
# assignment operation overload
check "$1" '[^\S\n\r]+('"$class"'[^\S\n\r]*&[^\S\n\r]*operator[^\S\n\r]*=[^\S\n\r]*\(((const +'"$class"'[^\S\n\r]*&[^\S\n\r]*)|('"$class"'([^\S\n\r]*&[^\S\n\r]*const +| +const[^\S\n\r]*&[^\S\n\r]*)))([_a-zA-Z][0-9a-zA-Z]*)?\);)'
# copy constructor
check "$1" '[^\S\n\r]+('"$class"'\(((const +'"$class"'[^\S\n\r]*&[^\S\n\r]*)|('"$class"'([^\S\n\r]*&[^\S\n\r]*const +| +const[^\S\n\r]*&[^\S\n\r]*)))([_a-zA-Z][0-9a-zA-Z]*)?\)\;)'
# default deconstructor
check "$1" '[^\S\n\r]+(~'"$class"'\(\);)'
# default constructor
check "$1" '[^\S\n\r]+('"$class"'\(\);)'
echo -e -n '\033[32;1m'
echo "$1 is canonical"
echo -e -n '\033[0m'