#!/bin/bash

for i in $(find . -type d); do if [ -f "$i/Makefile" ] ; then echo '--> '"$i"'/Makefile' '$: make' && cd "$i" && make san && ./$(cat Makefile | regex.py 'NAME=([\S]*)') && make fclean && cd - ; fi; done