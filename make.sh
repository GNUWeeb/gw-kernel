#!/usr/bin/env bash

export PREFIX="$PWD/build/opt/cross";
export TARGET=i686-elf;
export PATH="$PREFIX/bin:$PATH";

export CC=i686-elf-gcc;
export CXX=i686-elf-g++;
export AS=i686-elf-as;
export LD=i686-elf-ld;
export NASM=nasm;
export DD=dd;

export RM=rm;
export QEMU=qemu-system-x86_64;

make ${@};
