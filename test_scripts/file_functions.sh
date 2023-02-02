print_usage() {
    echo "$(basename -- $0): No argument supplied" >&2
    echo -e "Prints the functions declared in a file" >&2
    echo -e "\n\tUsage:\n\t\t$(basename -- $0) <file_name>.c" >&2
}

if [ -z "$1" ]
then
	print_usage
else
	cat "$1" | regex.py '(\w+[\s\*]+(\w+[\s\*]+)?(\w+[\s\*]+)?\w+\(.*\))\s?\n\{'
fi