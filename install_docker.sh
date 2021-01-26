brew update && brew upgrade
mkdir -p /tmp/.$USER-brew-locks
brew install docker && brew install docker-machine
docker-machine create --driver virtualbox default
docker-machine env default
eval $(docker-machine env default)
docker --version
