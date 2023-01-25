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
		echo >&2 "tests/test_utils/mocks/"$(dirname $chosenfilepath)/$basefilename"_mock."$extension
		echo "tests/test_utils/mocks/"$(dirname $chosenfilepath)/$basefilename"_mock."$extension
		mkdir -p "tests/test_utils/mocks/"$(dirname $chosenfilepath)/
		touch "tests/test_utils/mocks/"$(dirname $chosenfilepath)/$basefilename"_mock."$extension
	fi
fi