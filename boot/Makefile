# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
#

DD	= dd
RM	= rm
NASM	= nasm
QEMU	= qemu-system-x86_64

all: boot.bin

boot: boot.bin
	$(QEMU) -hda $(<)

boot.bin: boot.asm
	$(NASM) -fbin $(^) -o $(@)

clean:
	$(RM) -vf boot.bin

.PHONY: all clean boot
