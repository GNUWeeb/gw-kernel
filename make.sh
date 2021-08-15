#!/usr/bin/env bash

export PREFIX="$PWD/build/opt/cross";
export TARGET=i686-elf;
export PATH="$PREFIX/bin:$PATH";
make ${@};
