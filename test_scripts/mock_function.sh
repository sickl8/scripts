# 
# TODO: add wrapped function name to MOCKS in add_mocked_test() in the corresponding CMakeLists.txt
regex_proto='^\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*[_a-zA-Z][_a-zA-Z0-9]*\n*\s*\**\s*(\w+)\s*\([^0;{]+\)\s*\{'
regex_proto_plus_doxygen='/\*((?!\*/)[\s\S])*\*/\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*[_a-zA-Z][_a-zA-Z0-9]*\n*\s*\**\s*(\w+)\s*\([^0;{]+\)\s*\{'

match_proto() {
	regex.py '(^\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*\w+\n*\s*\**\s*('$1')\s*\([^0;{]+\)\s*\{)' -
}

match_return_type() {
	regex.py '^\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*(\w+)\n*\s+\**\s*('$1')\s*\([^0;{]+\)\s*\{' -
}

match_proto_with_doxygen_header() {
	regex.py '(/\*((?!\*/)[\s\S])*\*/\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*[_a-zA-Z][_a-zA-Z0-9]*\n*\s*\**\s*('$1')\s*\([^0;{]+\)\s*\{)' - false
}

if [ -z "$1" ]
then
	echo "No arguments were given"
else
	for file in $(find . -name '*.c')
	do
		if [ "$(grep $1 $file)" ]
		then
			proto=$(cat $file | match_proto_with_doxygen_header "$1")
			if [ "$proto" ]
			then
				echo "$file:";
				mock_file=$(create_mock_file.sh "$file");
				if [ "$mock_file" ]
				then
					if [ -z "$(cat $mock_file | match_proto $1)" ]
					then
						return_type=$(cat $file | match_return_type $1)
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