# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
#

QEMU = qemu-system-x86_64

all: $(BASE_DIR)/boot/gw-kernel.bin

$(BASE_DIR)/boot/boot.bin: $(BASE_DIR)/boot/boot.asm
	$(NASM) $(NASM_FLAGS) -fbin $(<) -o $(@)

$(BASE_DIR)/boot/kernel.o: $(BASE_DIR)/boot/kernel.asm
	$(NASM) $(NASM_FLAGS) -felf $(<) -o $(@)

$(BASE_DIR)/boot/kernel_full.o: $(BASE_DIR)/boot/kernel.o
	$(LD) $(LDFLAGS) -relocatable $(^) -o $(@)

$(BASE_DIR)/boot/kernel.bin: $(BASE_DIR)/boot/kernel_full.o $(BASE_DIR)/boot/linker.ld
	$(CC) $(CFLAGS) -T $(BASE_DIR)/boot/linker.ld $(<) -o $(@)

$(BASE_DIR)/boot/gw-kernel.bin: $(BASE_DIR)/boot/boot.bin $(BASE_DIR)/boot/kernel.bin
	$(DD) if=$(BASE_DIR)/boot/boot.bin > $(@)
	$(DD) if=$(BASE_DIR)/boot/kernel.bin >> $(@)
	$(DD) if=/dev/zero bs=512 count=100 >> $(@)

do_qemu_boot: $(BASE_DIR)/boot/gw-kernel.bin
	$(QEMU) -hda $(<)

boot_clean:
	$(RM) -vf \
	$(BASE_DIR)/boot/boot.bin \
	$(BASE_DIR)/boot/kernel.o \
	$(BASE_DIR)/boot/kernel_full.o \
	$(BASE_DIR)/boot/kernel.bin \
	$(BASE_DIR)/boot/gw-kernel.bin

.PHONY: all do_qemu_boot boot_clean
