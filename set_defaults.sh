#!/bin/bash
dfw () {
	defaults write -g $*
	defaults -currentHost write -g $*
}

dfw ApplePressAndHoldEnabled -bool false
dfw com.apple.swipescrolldirection -bool false
dfw InitialKeyRepeat -int 15
dfw KeyRepeat -int 2
dfw AppleInterfaceStyle -string Dark
