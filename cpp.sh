#!/bin/bash

for var in "$@"
do
    touch "$var.cpp" "$var.hpp"
	echo '#include "'"$var.hpp"'"' > "$var.cpp"
	class.sh "$var.hpp" "$var"
done