mv $1 /goinfre/$USER/$(basename "$1") && ln -s /goinfre/$USER/$(basename "$1") $(dirname "$1")/$(basename "$1")
