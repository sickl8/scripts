#
# TODO: add wrapped function name to MOCKS in add_mocked_test() in the corresponding CMakeLists.txt
# regex_proto='^\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*[_a-zA-Z][_a-zA-Z0-9]*\n*\s*\**\s*(\w+)\s*\([^;{]+\)\s*\{'
# regex_proto_plus_doxygen='/\*((?!\*/)[\s\S])*\*/\s*(?:(?:inline|static)\s+){0,2}(?!else|typedef|return)\n*[_a-zA-Z][_a-zA-Z0-9]*\n*\s*\**\s*(\w+)\s*\([^;{]+\)\s*\{'

if [ -z "$1" ]
then
	echo "No arguments were given"
else
	for file in $(find . -name '*.c')
	do
		if [ "$(grep $1 $file)" ]
		then
			proto=$(cat $file | match_proto_with_doxygen_header.sh "$1")
			if [ "$proto" ]
			then
				echo "$file:";
				mock_file=$(create_mock_file.sh "$file");
				if [ "$mock_file" ]
				then
					cmocka_headers=$(cat $mock_file | match_cmocka_headers.sh)
					if [ -z "$cmocka_headers" ]
					then
						echo 'cmocka headers in the correct order were not found, prepending them'
						for i in '\/\* Headers required by cmocka (refer to cmocka.h) \*\/' "#include <stdarg.h>" "#include <stddef.h>" "#include <setjmp.h>" "#include <stdint.h>" "#include <cmocka.h>"
						do
							sed -i '/'"$i"'/d' $mock_file
						done
						file_header=$(cat $mock_file | regex.py '(^(?<![\s\S\r])/\*((?!\*/)[\s\S])*\*/)' - f)
						file_header_nlines=$(cat $mock_file | regex.py '(^(?<![\s\S\r])/\*((?!\*/)[\s\S])*\*/)' - f | wc -l | xargs echo)
						mock_file_wo_header=$(cat $mock_file | sed '1,'"$file_header_nlines"d)
						mock_file_wo_header=$(printf '%s\n%s' "$(echo -e '/* Headers required by cmocka (refer to cmocka.h) */\n#include <stdarg.h>\n#include <stddef.h>\n#include <setjmp.h>\n#include <stdint.h>\n#include <cmocka.h>')" "$(echo "$mock_file_wo_header")")
						echo "$file_header" > "$mock_file"
						echo >> "$mock_file"
						echo "$mock_file_wo_header" >> "$mock_file"
					fi


					# include all headers from source file to mock file
					if [ "$2" = "-i" ]
					then
						cmocka_headers=$(cat $mock_file | match_cmocka_headers.sh)
						file_header=$(cat $mock_file | regex.py '(^(?<![\s\S\r])/\*((?!\*/)[\s\S])*\*/)' - f)
						file_header_nlines=$(cat $mock_file | regex.py '(^(?<![\s\S\r])/\*((?!\*/)[\s\S])*\*/)' - f | wc -l | xargs echo)
						mock_file_wo_header=$(cat $mock_file | sed '1,'"$file_header_nlines"d)
						includes=$(cat $file | match_includes.sh | tac)
						IFS=$'\n'
						for include in $includes
						do
							if [ -z "$(echo "$mock_file_wo_header" | grep "$include")" ]
							then
								echo "$include was not found, prepending it"
								mock_file_wo_header=$(printf '%s\n%s' "$include" "$(echo "$mock_file_wo_header")")
							fi
						done
						echo "$file_header" > "$mock_file"
						echo "$mock_file_wo_header" >> "$mock_file"
						unset IFS
					fi

					if [ -z "$(cat $mock_file | match_proto.sh __wrap_"$1")" ]
					then
						return_type=$(cat $file | match_return_type.sh $1 | sed 's/\s//g')
						# echo "file=$file"
						# echo "rt=$return_type"
						wrap_proto=$(echo "$proto" | sed 's/'"$1"'/'__wrap_"$1"'/g' | sed 's/@brief.*$/'"@brief Mocked function for @ref $1()"'/g')
						echo -e '\n\n'"$wrap_proto" >> "$mock_file" ;
						if [ "$return_type" != "void" ]
						then
							echo -e '    return ('"$return_type"')mock();' >> $mock_file;
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