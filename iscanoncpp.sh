#!/bin/bash
function d8() {
	date +%H:%M:%S\ %d/%m/%y
}
include="$(cat $1 | regex.py '#[^\S\n\r]*include[^\S\n\r]*\"(\w+.hpp)\"' | head -1)"
class_header="$(dirname $1)/""$include"
class="$(cat $class_header | regex.py 'class[^\S\n\r]\b(\w+)\b(?!\s*;)')"
# class="$(cat $1 | regex.py '#[^\S\n\r]*include[^\S\n\r]*"(\w+\.hpp)"')"
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
check "$1" ''$class'\s*&\s*'$class'\s*::\s*operator\s*=\s*\(((const +'$class'\s*&\s*)|('$class'(\s*&\s*const +| +const\s*&\s*)))[_a-zA-Z][0-9a-zA-Z]*\)'
# copy constructor
check "$1" ''$class'\s*::\s*'$class'\(((const +'$class'\s*&\s*)|('$class'(\s*&\s*const +| +const\s*&\s*)))([_a-zA-Z][0-9a-zA-Z]*)?\)'
# default deconstructor
check "$1" $class'\s*::\s*''~\s*'$class'\(\s*\)'
# default constructor
check "$1" $class'\s*::\s*'''$class'\(\s*\)'
echo -e -n '\033[32;1m'
echo "$1 is canonical"
echo -e -n '\033[0m'