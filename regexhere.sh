files=$(find . -type f)
for file in $files
do
	match=$(cat "$file" | regex.py "$1")
	if [ "$match" ]
	then
		echo "$file:"
		echo "$match"
	fi
done