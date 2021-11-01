#!/bin/bash
dfw () {
	defaults write -g $*
	defaults -currentHost write -g $*
}

dfw ApplePressAndHoldEnabled -bool false
dfw com.apple.swipescrolldirection -bool false
dfw InitialKeyRepeat -int 10
dfw KeyRepeat -int 1
dfw AppleInterfaceStyle -string Dark
