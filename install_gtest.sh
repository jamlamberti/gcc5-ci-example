#!/bin/bash

if [ ! -d "googletest" ]; then
    git clone https://github.com/google/googletest.git
fi

cd googletest
git pull
cmake .
make -j 8
