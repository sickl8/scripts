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
	echo "$3"
	if [ -z "$str" ];
	then
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
check "$1" '[^\S\n\r]+('"$class"'[^\S\n\r]*&[^\S\n\r]*operator[^\S\n\r]*=[^\S\n\r]*\(((const +'"$class"'[^\S\n\r]*&[^\S\n\r]*)|('"$class"'([^\S\n\r]*&[^\S\n\r]*const +| +const[^\S\n\r]*&[^\S\n\r]*)))([_a-zA-Z][0-9a-zA-Z]*)?\);)' \
"$class""$(echo -n -e '\t')"'&operator=(const '"$class"' &ref);'
# copy constructor
check "$1" '[^\S\n\r]+('"$class"'\(((const +'"$class"'[^\S\n\r]*&[^\S\n\r]*)|('"$class"'([^\S\n\r]*&[^\S\n\r]*const +| +const[^\S\n\r]*&[^\S\n\r]*)))([_a-zA-Z][0-9a-zA-Z]*)?\)\;)' \
"$class"'(const '"$class"' &ref);'
# default deconstructor
check "$1" '[^\S\n\r]+(~'"$class"'\(\);)' \
'~'"$class"'();'
# default constructor
check "$1" '[^\S\n\r]+('"$class"'\(\);)' \
"$class"'();'

suffix="$(d8 | tr ' ' _)"_"$(basename $1)"

cp "$1" /tmp/backup_"$(echo -n $suffix | tr '/' '_')"
cp "$tmp" "$1"