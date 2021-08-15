# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
#

LDFLAGS = -g
CFLAGS = -g -O0 -ffreestanding -nostdlib
NASM_FLAGS = -g
QEMU = qemu-system-x86_64

all: boot/gw-kernel.bin

boot/boot.bin: boot/boot.asm
	$(NASM) $(NASM_FLAGS) -fbin $(<) -o $(@)

boot/kernel.o: boot/kernel.asm
	$(NASM) $(NASM_FLAGS) -felf $(<) -o $(@)

boot/kernel_full.o: boot/kernel.o
	$(LD) $(LDFLAGS) -relocatable $(^) -o $(@)

boot/kernel.bin: boot/kernel_full.o boot/linker.ld
	$(CC) $(CFLAGS) -T boot/linker.ld $(<) -o $(@)

boot/gw-kernel.bin: boot/boot.bin boot/kernel.bin
	$(DD) if=boot/boot.bin > $(@)
	$(DD) if=boot/kernel.bin >> $(@)
	$(DD) if=/dev/zero bs=512 count=100 >> $(@)

boot: boot/gw-kernel.bin
	$(QEMU) -hda $(<)

clean:
	$(RM) -vf boot/boot.bin boot/kernel.o boot/kernel_full.o boot/kernel.bin boot/gw-kernel.bin

.PHONY: all clean boot
