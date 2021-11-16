#!/bin/bash
var=$(ls | tr ' ' '\n' | regex.py '(\w+)\.cpp\n\1\.hpp' - false | sed 's/\.cpp$//g' | sed 's/\.hpp$//g' | uniq)
for i in $var; do echo '-->' $i && iscanon.sh $i; done