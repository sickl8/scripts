if [ -z "$1" ] || [ "$#" -ne 1 ]
then # bad
	echo "Illegal number of arguments or 1st argument is empty"
	echo "Usage:"
	echo "      mv_to_goinfre.sh /path/to/folder"
else # good
	echo "DISCLAMER:"
	echo "       You have to use fix_goinfre_links in the same manner if you switch your session!"
	sleep 5
	name="$(basename -- "$1")"
	dir="$(dirname -- "$1")"
	user=$(whoami)
	echo "Removing \"/goinfre/$user/$name\"..."
	rm -rf "/goinfre/$user/$name"
	echo "Creating directory \"/goinfre/$user/$name\"..."
	mkdir "/goinfre/$user/$name"
	echo "Copying contents of \"$dir/$name/\" to \"/goinfre/$user/$name/\"..."
	rsync -a "$dir/$name/" "/goinfre/$user/$name/"
	echo "Removing \"$dir/$name/\" and making a symlinking it to \"/goinfre/$user/$name\""
	rm -rf "$dir/$name/" && ln -s "/goinfre/$user/$name"/ "$dir/$name"
fi
