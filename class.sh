if [ "$#" -ne 2 ]
then
	echo "Usage: cmd <file_name> <class_name>"
else
	file_name="$1"
	class_name="$2"
	cat ~/Desktop/templates/class.hpp | sed 's/CLASS_NAME/'"$class_name"'/g' > "$file_name"
	protect.sh "$file_name"
fi