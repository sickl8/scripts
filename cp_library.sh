#!/bin/bash

_copy () {
	user="$(whoami)"
	cp -r /Users/"$user"/Desktop/myLibrary/"$1"/* /goinfre/"$user"/"$1"/
}

_copy Google
_copy Code
