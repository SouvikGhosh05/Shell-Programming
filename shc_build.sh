#! /bin/bash

if ! which shc > /dev/null; then
    echo "shc not installed, installing now"
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:neurobin/ppa -y
    sudo apt-get update
    sudo apt-get install shc -y
fi

DIR="src/*.sh"

build_binary() {
    for filename in $DIR; do
        
        name=${filename##*/} 
        shc -f "src/$name" -o "bin/${name%%.*}"
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
