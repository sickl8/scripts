#!/bin/bash
var=$(find . | regex.py '([\s\S]*)\.cpp\n\1\.hpp' - false | uniq)
for i in $var; do echo '-->' $i && iscanon.sh $i; done