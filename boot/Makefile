# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
#

DEP_DIRS += $(BASE_DEP_DIR)/boot

OBJ_PRE_CC += \
	$(BASE_DIR)/boot/kernel_entry.o \
	$(BASE_DIR)/boot/kernel.o \
	$(BASE_DIR)/boot/print_vga.o


$(BASE_DIR)/boot/kernel_entry.o: $(BASE_DIR)/boot/kernel_entry.asm
	$(NASM_PRINT)
	$(Q)$(NASM) $(NASM_FLAGS) -felf $(<) -o $(@)


$(BASE_DIR)/boot/kernel.o: $(BASE_DIR)/boot/kernel.c
	$(CC_PRINT)
	$(Q)$(CC) $(DEPFLAGS) $(CFLAGS) -c $(O_TO_C) -o $(@)


$(BASE_DIR)/boot/print_vga.o: $(BASE_DIR)/boot/print_vga.c
	$(CC_PRINT)
	$(Q)$(CC) $(DEPFLAGS) $(CFLAGS) -c $(O_TO_C) -o $(@)


$(BASE_DIR)/boot/boot.bin: $(BASE_DIR)/boot/boot.asm
	$(NASM_PRINT)
	$(Q)$(NASM) $(NASM_FLAGS) -fbin $(<) -o $(@)

