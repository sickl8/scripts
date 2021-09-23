if [ -z "$1" ] || [ "$#" -ne 1 ]
then
	#bad
	echo Illegal
else
	#good
	name="$(basename -- "$1")"
	dir="$(dirname -- "$1")"
	user="$(whoami)"
	mkdir -p "/goinfre/$user/$name"
   	rm -rf "$dir/$name" && ln -s "/goinfre/$user/$name" "$dir/$name"	
fi
