
if [ -z "$1" ]
then
    echo >&2 "$(basename -- $0): No argument supplied"
else
	current_path=$(pwd)
    errors=$(/usr/bin/cmake --build $current_path/build --config Debug --target $1 -j 10 -- 2>&1 | regex.py '#include\s+[<"](\S+)[>"]' | awk 'NR==1')
	if [ -z "$errors" ]
	then
		echo >&2 "No include errors found on cmakelist build"
	fi
fi

if [ -z "$errors" ]
then
	echo 0
	exit 0
else
	echo 1
	include_definition=$errors
	extension="${include_definition##*.}"
	listfiles=$(findhere.sh "$include_definition")
	chosenfilepath=""

	c_test_filename=$1".c"
	c_test_filepaths=$(findhere.sh "$c_test_filename")
	chosen_c_test_file=""


	# Check for< Test_*.c file or multiple files with same name
	if [ -z "$listfiles" ]
	then
		echo >&2"$(basename -- $0): $include_definition: No such file or directory"
	else
		if (( $(grep -c . <<<"$listfiles") > 1 )); then
			echo >&2 "---> Multiple candidates for \"$include_definition\", please choose one:"
			select i in $listfiles; do chosenfilepath=$i; break; done
		else
			chosenfilepath=$listfiles
		fi
	fi

	# Check for missing Test_*.c file or multiple files with same name
	if [ -z "$c_test_filepaths" ]
	then
		echo >&2 "$(basename -- $0): $c_test_filepaths: No such file or directory"
	else
		if (( $(grep -c . <<<"$c_test_filepaths") > 1 )); then
			echo >&2 "---> Multiple candidates for \"$c_test_filename\", please choose one:"
			select i in $c_test_filepaths; do chosen_c_test_file=$i; break; done
		else
			chosen_c_test_file=$c_test_filepaths
		fi
	fi
	if [[ ! -z "$HOME" ]] && [[ ! -z "$include_definition" ]] && [[ ! -z "$chosenfilepath" ]] && [[ ! -z "$chosen_c_test_file" ]]
	then
		echo $HOME
		echo $include_definition
		echo $chosenfilepath
		echo $chosen_c_test_file
	else
		echo >&2 "HOME=$HOME"
		echo >&2 "include_definition=$include_definition"
		echo >&2 "chosenfilepath=$chosenfilepath"
		echo >&2 "chosen_c_test_file=$chosen_c_test_file"
		echo >&2 "Could not find definition to:$include_definition"
		echo "Error"
	fi
fi