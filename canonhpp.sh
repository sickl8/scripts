#!/bin/bash
function d8() {
	date +%H:%M:%S\ %d/%m/%y
}
class="$(cat $1 | regex.py 'class[^\S\n\r]\b(\w+)\b(?!\s*;)')"
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
		cat "$tmp" | regex.py '[\s\S]*public:' - false >> $tmp2
		echo "$tab""$3" >> $tmp2
		cat "$tmp" | regex.py 'public:([\s\S]*)' - false | awk 'NR>2 {print last} {last=$0}' >> $tmp2
		cat $tmp2 > $tmp
	# else
	# 	echo "not an empty string"
	fi
}
# assignment operation overload
check "$1" ''"$class"'\s*&\s*operator\s*=\s*\(\s*(('"$class"'\s*(const\s*&|& *const))|(const\s*'"$class"'\s*&))\s*([a-zA-Z_][a-zA-Z0-9]*)?\s*\)\s*;' \
"$class""$(echo -n -e '\t')"'&operator=(const '"$class"' &ref);'
# copy constructor
check "$1" ''"$class"'\s*\(\s*(('"$class"'\s*(const\s*&|& *const))|(const\s*'"$class"'\s*&))\s*([a-zA-Z_][a-zA-Z0-9]*)?\s*\)\s*;' \
"$class"'(const '"$class"' &ref);'
# default deconstructor
check "$1" '(\s'"$class"'\s*\(\s*(void)?\)\s*;)' \
'~'"$class"'();'
# default constructor
check "$1" '(~'"$class"'\s*\(((\s*)|(void))\)\s*;)' \
"$class"'();'

suffix="$(d8 | tr ' ' _)"_"$(basename $1)"

cp "$1" /tmp/backup_"$(echo -n $suffix | tr '/' '_')"
cp "$tmp" "$1"