# SPDX-License-Identifier: GPL-2.0


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

HOSTCC := cc
HOSTCXX := cxx
HOSTLD := ld
MKFLAGS := --no-print-directory

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
