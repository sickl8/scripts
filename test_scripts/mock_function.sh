# 
# TODO: add wrapped function name to MOCKS in add_mocked_test() in the corresponding CMakeLists.txt
if [ -z "$1" ]
then
	echo "No arguments were given"
else
	for file in $(find . -name '*.c')
	do
		if [ "$(grep $1 $file)" ]
		then
			proto=$(cat $file | regex.py '(^\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*\w+\n*\s*\**\s*('$1')\s*\([^0;{]+\)\s*\{)' -)
			if [ "$proto" ]
			then
				echo "$file:";
				mock_file=$(create_mock_file.sh "$file");
				if [ "$mock_file" ]
				then
					if [ -z "$(cat $mock_file | regex.py '(^\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*\w+\n*\s*\**\s*('__wrap_$1')\s*\([^0;{]+\)\s*\{)' -)" ]
					then
						return_type=$(cat $file | regex.py '^\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*(\w+)\n*\s+\**\s*('$1')\s*\([^0;{]+\)\s*\{' -)
						# echo "file=$file"
						# echo "rt=$return_type"
						wrap_proto=$(echo "$proto" | sed 's/'"$1"'/'__wrap_"$1"'/g')
						echo -e '\n'"$wrap_proto" >> "$mock_file" ;
						if [ "$return_type" != "void" ]
						then
							echo -e '\treturn ('"$return_type"')mock();' >> $mock_file;
						else
							echo >> $mock_file;
						fi
						echo -e '}' >> $mock_file;
					else
						echo 'wrapper for '"$1"' already exists!!'
					fi
					break;
				fi
			fi
		fi
	done
fi