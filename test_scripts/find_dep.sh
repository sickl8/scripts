
if [ -z "$1" ]
then
    echo "$(basename -- $0): No argument supplied"
else
    errors=$(/usr/bin/cmake --build /home/anouar/workspace/safety_control_unit/build --config Debug --target $1 -j 10 -- 2>&1 | regex.py '#include\s+[<"](\S+)[>"]')
fi

if [ -z "$errors" ]
then
    echo "no errors found"
else
	filename=$errors
	extension="${filename##*.}"
	basefilename="${filename%.*}"
	listfiles=$(findhere.sh "$filename")
	chosenfilepath=""
	test_file=$(findhere.sh "$1".c)
	dir_path=$(dirname "$test_file")

	if [ -z "$listfiles" ]
	then
		echo "$(basename -- $0): $errors: No such file or directory"
	else
		if (( $(grep -c . <<<"$listfiles") > 1 )); then
			echo >&2 "---> Multiple candidates for \"$filename\", please choose one:"
			select i in $listfiles; do chosenfilepath=$i; break; done
		else
			chosenfilepath=$listfiles
			echo >&2 "---> Single candidate found:"
		fi
    	echo $chosenfilepath
		echo $filename
		echo ""$dir_path"/CMakeList.txt"

	fi
fi