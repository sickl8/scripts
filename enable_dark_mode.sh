#!/bin/bash
dfw () {
	defaults write -g $*
	defaults -currentHost write -g $*
}

dfw AppleInterfaceStyle -string Dark
