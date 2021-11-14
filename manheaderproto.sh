#!/bin/bash

man $2 $1 | col -bx | regex.py '[\s\S]*(?<=LEGACY SYNOPSIS)' - false | regex.py '#include <.*>'