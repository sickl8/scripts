rm -rf ~/.brew /goinfre/$USER/.brew
git clone --depth=1 https://github.com/Homebrew/brew /goinfre/$USER/.brew && ln -s /goinfre/$USER/.brew /Users/$USER/.brew && export PATH=$HOME/.brew/bin:$PATH && brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.bashrc
