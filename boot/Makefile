# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
#

$(BASE_DIR)/boot/boot.bin: $(BASE_DIR)/boot/boot.asm
	$(NASM) $(NASM_FLAGS) -fbin $(<) -o $(@)

$(BASE_DIR)/boot/__kernel.asm.o: $(BASE_DIR)/boot/kernel.asm
	$(NASM) $(NASM_FLAGS) -g -felf $(<) -o $(@)

$(BASE_DIR)/boot/kernel.o: $(BASE_DIR)/boot/kernel.c
	$(CC) $(CFLAGS) -ggdb3 -c $(^) -o $(@)

$(BASE_DIR)/boot/kernelfull.o: $(BASE_DIR)/boot/__kernel.asm.o $(BASE_DIR)/boot/kernel.o
	$(LD) $(LDFLAGS) -g -relocatable $(^) -o $(@)

$(BASE_DIR)/boot/kernel.bin: $(BASE_DIR)/boot/kernelfull.o
	$(CC) $(CFLAGS) -T $(BASE_DIR)/scripts/build/linker.ld $(^) -o $(@)

$(BASE_DIR)/boot/gw-kernel.bin: $(BASE_DIR)/boot/boot.bin $(BASE_DIR)/boot/kernel.bin
	$(DD) if=$(BASE_DIR)/boot/boot.bin > $(@)
	$(DD) if=$(BASE_DIR)/boot/kernel.bin >> $(@)
	$(DD) if=/dev/zero bs=512 count=1000 >> $(@)

do_qemu_boot: $(BASE_DIR)/boot/gw-kernel.bin
# 	$(QEMU) -hda $(<)

boot_clean:
	$(Q)$(RM) -vf \
		$(BASE_DIR)/boot/boot.bin \
		$(BASE_DIR)/boot/kernel.o \
		$(BASE_DIR)/boot/kernelfull.o \
		$(BASE_DIR)/boot/kernel.bin \
		$(BASE_DIR)/boot/gw-kernel.bin

.PHONY: all do_qemu_boot boot_clean
