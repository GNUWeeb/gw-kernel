# SPDX-License-Identifier: GPL-2.0

VERSION	= 0
PATCHLEVEL = 0
SUBLEVEL = 0
EXTRAVERSION =
NAME = GWK

BASE_DIR	:= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
BASE_DIR	:= $(strip $(patsubst %/, %, $(BASE_DIR)))
BASE_DEP_DIR	:= $(BASE_DIR)/.deps
MAKEFILE_FILE	:= $(lastword $(MAKEFILE_LIST))
INCLUDE_DIR	= -I$(BASE_DIR)/include

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
	-nostdlib \
	-DVERSION="$(VERSION)" \
	-DPATCHLEVEL="$(PATCHLEVEL)" \
	-DSUBLEVEL="$(SUBLEVEL)" \
	-DEXTRAVERSION="\"$(EXTRAVERSION)\"" \
	-DNAME="\"$(NAME)\""

LDFLAGS = -g
NASM_FLAGS = -g

export VERSION
export PATCHLEVEL
export SUBLEVEL
export EXTRAVERSION
export NAME
export BASE_DIR
export BASE_DEP_DIR
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

ifneq ($(words $(subst :, ,$(BASE_DIR))), 1)
$(error Source directory cannot contain spaces or colons)
endif

all:
	+$(MAKE) $(MKFLAGS) -f kernel/Makefile
	+$(MAKE) $(MKFLAGS) -f boot/Makefile

clean:
	+$(MAKE) $(MKFLAGS) -f kernel/Makefile clean
	+$(MAKE) $(MKFLAGS) -f boot/Makefile clean

boot:
	+$(MAKE) $(MKFLAGS) -f boot/Makefile boot

.PHONY: all clean boot
