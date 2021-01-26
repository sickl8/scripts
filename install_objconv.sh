curl -L https://www.agner.org/optimize/objconv.zip > /tmp/objconv.zip
mkdir -p /tmp/build-objconv
unzip /tmp/objconv.zip -d /tmp/build-objconv
cd /tmp/build-objconv
unzip source.zip -d src
g++ -o objconv -O2 src/*.cpp --prefix="~/.brew/objconv/"
mkdir -p ~/.brew/objconv/bin
cp objconv ~/.brew/objconv/bin