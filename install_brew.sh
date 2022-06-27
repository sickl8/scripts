if [ "$USER" == "" ]
then
	echo the USER environment variable is not set, export USER=your_login
else
	echo installing...
	rm -rf ~/.brew /goinfre/$USER/.brew
	git clone --depth=1 https://github.com/Homebrew/brew /goinfre/$USER/.brew && ln -s /goinfre/$USER/.brew /Users/$USER/.brew && $HOME/.brew/bin/brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.bashrc && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.zshrc
fi
