#!/bin/bash
function d8() {
	date +%H:%M:%S\ %d/%m/%y
}
include="$(cat $1 | regex.py '#[^\S\n\r]*include[^\S\n\r]*\"(\w+.hpp)\"' | head -1)"
class_header="$(dirname $1)/""$include"
class="$(cat $class_header | regex.py 'class[^\S\n\r]\b(\w+)\b(?!\s*;)')"
# echo $class
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
		echo "$3"
		# echo "empty string"
		> $tmp2
		cat "$tmp" >> $tmp2
		echo >> $tmp2
		echo -e "$3" >> $tmp2
		cat $tmp2 > $tmp
	# else
	# 	echo "not an empty string"
	fi
}
# assignment operation overload
check "$1" ''"$class"'\s*&\s*'"$class"'\s*::\s*operator\s*=\s*\(\s*(('"$class"'\s*(const\s*&|& *const))|(const\s*'"$class"'\s*&))\s*([a-zA-Z_][a-zA-Z0-9]*)?\s*\)' \
$class"$(echo -n -e '\t')"\&$class'::operator=(const '$class' &ref) {\n\treturn *this;\n}'
# copy constructor
check "$1" ''"$class"'\s*::\s*'$class'\(\s*(('"$class"'\s*(const\s*&|& *const))|(const\s*'"$class"'\s*&))\s*([a-zA-Z_][a-zA-Z0-9]*)?\s*\)' \
$class'::'$class'(const '$class' &ref) {\n\t\n}'
# default deconstructor
check "$1" ''"$class"'\s*::\s*''~\s*'$class'\(\s*\)' \
$class'::~'$class'() {\n\t\n}'
# default constructor
check "$1" ''"$class"'\s*::\s*'''$class'\(\s*\)' \
"$class::$class"'() {\n\t\n}'

suffix="$(d8 | tr ' ' _)"_"$(basename $1)"

cp "$1" /tmp/backup_"$(echo -n $suffix | tr '/' '_')"
cp "$tmp" "$1"