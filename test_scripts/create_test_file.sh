# This script only creates mock files for SCU, haven't worked on armbase yet to adapt the script to it
print_usage() {
    echo "$(basename -- $0): No argument supplied" >&2
    echo -e "\tUsage:\n\t\t$(basename -- $0) <file_name>.c" >&2
}

if [ -z "$1" ]
then
	print_usage
else
	filename=$(basename -- "$1")
	extension="${filename##*.}"
	basefilename="${filename%.*}"
	listfiles=$(findhere.sh "$filename")
	chosenfilepath=""
	if [ -z "$listfiles" ]
	then
		echo "$(basename -- $0): $1: No such file or directory"
	else
		if (( $(grep -c . <<<"$listfiles") > 1 )); then
			echo >&2 "---> Multiple candidates for \"$filename\", please choose one:"
			select i in $listfiles; do chosenfilepath=$i; break; done
		else
			chosenfilepath=$listfiles
			echo >&2 "---> Single candidate found:"
		fi
		echo >&2 "chosen file path: $chosenfilepath"
		echo >&2 -n "creating ---> "
		path="tests/"$(dirname $chosenfilepath)/"test_"$basefilename.$extension
		echo >&2 "$path"
		echo "$path"
		mkdir -p $(dirname -- $path)

		CMAKELISTEMPLATE=tests/doc/template

		cat $CMAKELISTEMPLATE/test_template.c | sed 's/test_template/'"test_$basefilename"'/g' >> "$path"
		echo >> $(dirname -- $path)/CMakeLists.txt
		cat $CMAKELISTEMPLATE/CMakeLists.txt | sed 's/template/'"$basefilename"'/g' | sed 's/TEMPLATE/'"${basefilename^^}"'/g' | sed 's#/src_file.c#'"${chosenfilepath:1}"'#'>> $(dirname -- $path)/CMakeLists.txt
	fi
fi