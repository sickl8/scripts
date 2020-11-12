#!/bin/bash

rm -rf ~/.brew ~/.docker ~/VirtualBox\ VMs /goinfre/$(whoami)/.brew /goinfre/$(whoami)/.docker /goinfre/$(whoami)/VirtualBox\ VMs
git clone --depth=1 https://github.com/Homebrew/brew /goinfre/$(whoami)/.brew && ln -s /goinfre/$(whoami)/.brew ~/.brew
if [ ! $(which brew) ]
then
	export PATH=$HOME/.brew/bin:$PATH
	if [ $SHELL = $(which bash) ]
	then
		echo 'export PATH=$HOME/.brew/bin:$PATH' >> ~/.bashrc
	elif [ $SHELL = $(which zsh) ]
	then
		echo 'export PATH=$HOME/.brew/bin:$PATH' >> ~/.zshrc
	else
		echo "YOU'RE NOT USING BASH OR ZSH, YOU'LL HAVE TO DO THE EXPORT MANUALLY"
	fi
fi
mkdir -p /tmp/.$(whoami)-brew-locks
mkdir -p /goinfre/$(whoami)/.brew/var/homebrew
ln -s /tmp/.$(whoami)-brew-locks /goinfre/$(whoami)/.brew/var/homebrew/locks
brew update && brew upgrade
mkdir -p /tmp/.$(whoami)-brew-locks
brew install docker && brew install docker-machine
docker-machine create --driver virtualbox default
docker-machine env default
mkdir -p ~/.docker && mv ~/.docker /goinfre/$(whoami)/.docker && ln -s /goinfre/$(whoami)/.docker ~/.docker
mkdir -p ~/VirtualBox\ VMs && mv ~/VirtualBox\ VMs /goinfre/$(whoami)/VirtualBox\ VMs && ln -s /goinfre/$(whoami)/VirtualBox\ VMs ~/VirtualBox\ VMs
eval $(docker-machine env default)
# and finally to test run:
docker --version
brew --version
