# echo $1
# echo $2
regex.py '\w+\n* +'"$1"'\([^)]*\)\s*;' "$(man $2 $1 | col -bx)" | xargs echo
