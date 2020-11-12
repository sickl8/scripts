/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall.sh)"
rm -rf $HOME/.brew
git clone --depth=1 https://github.com/Homebrew/brew $HOME/.brew && export PATH=$HOME/.brew/bin:$PATH && brew update && echo "export PATH=$HOME/.brew/bin:$PATH" >> ~/.bashrc
mv ~/.brew /goinfre/$USER/.
ln -s /goinfre/$USER/.brew /Users/$USER/.brew