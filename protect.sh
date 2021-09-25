if [ -z "$1" ]
then
	# bad
	echo
else
	# good
	fullfile="$1"
	filename=$(basename -- "$fullfile")
	extension="${filename##*.}"
	filename="${filename%.*}"
	def=__$(echo "$filename" | tr '[:lower:]' '[:upper:]')_$(echo "$extension" | tr '[:lower:]' '[:upper:]')__
	echo -e "#ifndef $def\n# define $def\n" > /tmp/temptemp
	cat "$1" >> /tmp/temptemp
	echo -e "\n#endif" >> /tmp/temptemp
	cp /tmp/temptemp "$1"
fi
