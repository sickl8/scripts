if [ $# -ne 2 ]; then
	echo "Usage: fix_metadata <path/to/source> <path/to/destination>"
	exit
fi
ffmpeg -i $1 -metadata key=value -codec copy $2
