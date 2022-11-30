
if [ -z "$1" ]
then
    echo >&2 "$(basename -- $0): No argument supplied"
else
	cat "$1" | regex.py '(\w+[\s\*]+(\w+[\s\*]+)?(\w+[\s\*]+)?\w+\(.*\))\s?\n\{'
fi