#
# SPDX-License-Identifier: GPL-2.0-only
#
# @author Ammar Faizi <ammarfaizi2@gmail.com> https://www.facebook.com/ammarfaizi2
# @license GPL-2.0-only
#
# GNU/Weeb Kernel
#
# Copyright (C) 2021  Ammar Faizi
#

VERSION	= 0
PATCHLEVEL = 0
SUBLEVEL = 0
EXTRAVERSION :=
NAME =
TARGET_BIN = gwkernel.bin
PACKAGE_NAME = $(TARGET_BIN)-$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)

GIT_HASH = $(shell git log --pretty=format:'%H' -n 1)
EXTRAVERSION := $(EXTRAVERSION)-$(GIT_HASH)

#
# Bin
#
NASM	:= nasm
AS	:= as
HOSTCC 	:= cc
HOSTCXX	:= c++
HOSTLD	:= $(CXX)
RM	:= rm
MKDIR	:= mkdir
STRIP	:= strip
OBJCOPY	:= objcopy
OBJDUMP	:= objdump
READELF	:= readelf
CC	:= i686-elf-gcc
CXX	:= i686-elf-g++
LD	:= i686-elf-ld
QEMU	:= qemu-system-x86_64
DD	:= dd

NASM_FLAGS := -O2 -g

# `C_CXX_FLAGS` will be appended to `CFLAGS` and `CXXFLAGS`.
C_CXX_FLAGS := \
	-ggdb3 \
	-fstrict-aliasing \
	-fno-stack-protector \
	-fno-omit-frame-pointer \
	-nostdlib \
	-nostartfiles \
	-nodefaultlibs \
	-ffreestanding \
	-fno-builtin \
	-falign-jumps \
	-falign-functions \
	-falign-labels \
	-falign-loops \
	-fstrength-reduce \
	-D_GNU_SOURCE \
	-DVERSION=$(VERSION) \
	-DPATCHLEVEL=$(PATCHLEVEL) \
	-DSUBLEVEL=$(SUBLEVEL) \
	-DEXTRAVERSION="\"$(EXTRAVERSION)\"" \
	-DNAME="\"$(NAME)\""

C_CXX_FLAGS_RELEASE := -DNDEBUG
C_CXX_FLAGS_DEBUG :=

ifndef DEFAULT_OPTIMIZATION
	DEFAULT_OPTIMIZATION := -O2
endif

STACK_USAGE_SIZE := 2097152

GCC_WARN_FLAGS := \
	-Wall \
	-Wextra \
	-Wformat \
	-Wformat-security \
	-Wformat-signedness \
	-Wsequence-point \
	-Wstrict-aliasing=3 \
	-Wstack-usage=$(STACK_USAGE_SIZE) \
	-Wunsafe-loop-optimizations

CLANG_WARN_FLAGS := \
	-Wall \
	-Wextra \
	-Weverything \
	-Wno-padded \
	-Wno-unused-macros \
	-Wno-covered-switch-default \
	-Wno-disabled-macro-expansion \
	-Wno-language-extension-token \
	-Wno-used-but-marked-unused \
	-Wno-gnu-statement-expression

BASE_DIR	:= $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
BASE_DIR	:= $(strip $(patsubst %/, %, $(BASE_DIR)))
BASE_DEP_DIR	:= $(BASE_DIR)/.deps
MAKEFILE_FILE	:= $(lastword $(MAKEFILE_LIST))
INCLUDE_DIR	= -I$(BASE_DIR)


ifneq ($(words $(subst :, ,$(BASE_DIR))), 1)
$(error Source directory cannot contain spaces or colons)
endif

include $(BASE_DIR)/scripts/build/flags.make
include $(BASE_DIR)/scripts/build/print.make

#
# These empty assignments force the variables to be a simple variable.
#
OBJ_CC		:=

#
# OBJ_PRE_CC is a collection of object files which the compile rules are
# defined in sub Makefile.
#
OBJ_PRE_CC	:=

#
# OBJ_TMP_CC is a temporary variable which is used in the sub Makefile.
#
OBJ_TMP_CC	:=


all: $(TARGET_BIN)


# Include sub directories.
include $(BASE_DIR)/kernel/Makefile
include $(BASE_DIR)/boot/Makefile


#
# Create dependency directories
#
$(DEP_DIRS):
	$(MKDIR_PRINT)
	$(Q)$(MKDIR) -p $(@)


#
# Add more dependency chain to objects that are not compiled from the main
# Makefile (the main Makefile is *this* Makefile).
#
$(OBJ_CC): $(MAKEFILE_FILE) | $(DEP_DIRS)
$(OBJ_PRE_CC): $(MAKEFILE_FILE) | $(DEP_DIRS)


#
# Compile object from the main Makefile (the main Makefile is *this* Makefile).
#
$(OBJ_CC):
	$(CC_PRINT)
	$(CC) $(DEPFLAGS) $(CFLAGS) -c $(O_TO_C) -o $(@)


#
# Include generated dependencies
#
-include $(OBJ_CC:$(BASE_DIR)/%.o=$(BASE_DEP_DIR)/%.d)
-include $(OBJ_PRE_CC:$(BASE_DIR)/%.o=$(BASE_DEP_DIR)/%.d)


$(BASE_DIR)/kernelfull.o: $(OBJ_PRE_CC)
	$(LD_PRINT)
	$(Q)$(LD) $(LDFLAGS) -g -relocatable $(^) -o $(@)


$(BASE_DIR)/kernelfull.bin: $(BASE_DIR)/kernelfull.o
	$(CC_PRINT)
	$(Q)$(CC) $(CFLAGS) -T $(BASE_DIR)/scripts/build/linker.ld $(^) -o $(@)


$(TARGET_BIN): $(BASE_DIR)/boot/boot.bin $(BASE_DIR)/kernelfull.bin
	$(DD_PRINT)
	$(Q)$(DD) if=$(BASE_DIR)/boot/boot.bin > $(@)
	$(Q)$(DD) if=$(BASE_DIR)/kernelfull.bin >> $(@)
	$(Q)$(DD) if=/dev/zero bs=512 count=1000 >> $(@)


qemu_boot: $(TARGET_BIN)
	$(Q)$(QEMU) -hda $(TARGET_BIN)


clean:
	$(Q)$(RM) -vf \
		$(BASE_DIR)/boot/boot.bin \
		$(BASE_DIR)/kernelfull.o \
		$(BASE_DIR)/kernelfull.bin \
		$(TARGET_BIN) \
		$(OBJ_CC) \
		$(OBJ_PRE_CC)


.PHONY: all clean
