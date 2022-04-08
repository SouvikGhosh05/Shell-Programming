#! /bin/bash

if ! type -P shc > /dev/null; then
    echo "shc not installed, installing now"
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:neurobin/ppa -y
    sudo apt-get update
    sudo apt-get install shc -y
fi

DIR="src/*.sh"

build_binary() {
    for filename in $DIR; do
        
        name=${filename##*/}                        # Remove pattern from left, e.g. "src/foo.sh" -> "foo.sh" where, pattern is "/"
        shc -f "src/$name" -o "bin/${name%%.*}"     # Remove pattern from right, e.g. "foo.sh" -> "foo" where, pattern is "."
    done
}

if [ ! -d "bin" ]; then     # if 'bin' directory does not exist
    mkdir bin
    build_binary
    echo "All binaries created"
else 
    build_binary
    echo "All binaries created"
fi
