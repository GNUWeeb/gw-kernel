# SPDX-License-Identifier: GPL-2.0


INCLUDE_DIR = -Isrc/
CFLAGS = $(INCLUDE_DIR) \
	-g \
	-O0 \
	-Wall \
	-Wextra \
	-nostdlib \
	-nostartfiles \
	-nodefaultlibs \
	-ffreestanding \
	-falign-functions \
	-fno-omit-frame-pointer \
	-nostdlib

LDFLAGS = -g
NASM_FLAGS = -g

export INCLUDE_DIR
export CFLAGS
export LDFLAGS
export NASM_FLAGS

ifdef TARGET
	CC := $(TARGET)-gcc
	CXX := $(TARGET)-g++
	AS := $(TARGET)-as
	LD := $(TARGET)-ld
else
	CC := gcc
	CXX := g++
	AS := as
	LD := ld
endif

export NASM=nasm
export CC
export CXX
export AS
export LD

DD := dd
HOSTCC := cc
HOSTCXX := cxx
HOSTLD := ld
MKFLAGS := --no-print-directory

export DD
export HOSTCC
export HOSTCXX
export HOSTLD
export MKFLAGS

all:
	+$(MAKE) $(MKFLAGS) -f boot/Makefile

clean:
	+$(MAKE) $(MKFLAGS) -f boot/Makefile clean

boot:
	+$(MAKE) $(MKFLAGS) -f boot/Makefile boot

.PHONY: all clean boot
