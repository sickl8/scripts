if [ -z "$1" ]
then
    echo "$(basename -- $0): No argument supplied"
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
		touch "$path"
		cmakelistemplate=tests/doc/template
		echo >> $(dirname -- $path)/CMakeLists.txt
		cat $cmakelistemplate/CMakeLists.txt | sed 's/template/'"$basefilename"'/g' >> $(dirname -- $path)/CMakeLists.txt
	fi
fi