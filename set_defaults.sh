#!/bin/bash
defaults write -g ApplePressAndHoldEnabled -bool false
defaults -currentHost write -g ApplePressAndHoldEnabled -bool false
defaults write -g com.apple.swipescrolldirection -bool false
defaults -currentHost write -g com.apple.swipescrolldirection -bool false
defaults write -g com.apple.swipescrolldirection -bool false
defaults -currentHost write -g com.apple.swipescrolldirection -bool false
defaults write -g InitialKeyRepeat -int 10
defaults -currentHost write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10
defaults -currentHost write -g KeyRepeat -int 1