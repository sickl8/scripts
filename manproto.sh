# echo $1
# echo $2
man $2 $1 | col -bx | regex.py 'SYNOPSIS([\S\s]*)DESCRIPTION' - 0 | regex.py '\w+\s*\**\s*'"$1"'\([^\)]*\);'
