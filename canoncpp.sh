#!/bin/bash
function d8() {
	date +%H:%M:%S\ %d/%m/%y
}
include="$(cat $1 | regex.py '#[^\S\n\r]*include[^\S\n\r]*\"(\w+.hpp)\"')"
class_header="$(dirname $1)/""$include"
class="$(cat $class_header | regex.py 'class[^\S\n\r]+([_a-zA-Z][0-9a-zA-Z]*)')"
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
		echo "$3" >> $tmp2
		cat $tmp2 > $tmp
	# else
	# 	echo "not an empty string"
	fi
}
# assignment operation overload
check "$1" ''$class'\s*&\s*'$class'\s*::\s*operator\s*=\s*\(((const +'$class'\s*&\s*)|('$class'(\s*&\s*const +| +const\s*&\s*)))[_a-zA-Z][0-9a-zA-Z]*\)' \
$class"$(echo -n -e '\t')"\&$class'::operator=(const '$class' &ref) {}'
# copy constructor
check "$1" ''$class'\s*::\s*'$class'\(((const +'$class'\s*&\s*)|('$class'(\s*&\s*const +| +const\s*&\s*)))([_a-zA-Z][0-9a-zA-Z]*)?\)' \
$class'::'$class'(const '$class' &ref) {}'
# default deconstructor
check "$1" $class'\s*::\s*''~\s*'$class'\(\s*\)' \
$class'::~'$class'() {}'
# default constructor
check "$1" $class'\s*::\s*'''$class'\(\s*\)' \
"$class::$class"'() {}'

suffix="$(d8 | tr ' ' _)"_"$(basename $1)"

cp "$1" /tmp/backup_"$(echo -n $suffix | tr '/' '_')"
cp "$tmp" "$1"