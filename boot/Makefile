# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
#

DEP_DIRS += $(BASE_DEP_DIR)/boot

OBJ_PRE_CC += \
	$(BASE_DIR)/boot/kernel_entry.o \
	$(BASE_DIR)/boot/kernel.o \
	$(BASE_DIR)/boot/vga_print.o \
	$(BASE_DIR)/boot/idt.o


BOOT_FRAGMENTS := \
	$(BASE_DIR)/boot/boot_fragments/00_boot_header.asm \
	$(BASE_DIR)/boot/boot_fragments/01_gdt_entry.asm \
	$(BASE_DIR)/boot/boot_fragments/02_boot_footer.asm


$(BASE_DIR)/boot/kernel_entry.o: $(BASE_DIR)/boot/kernel_entry.asm
	$(NASM_PRINT)
	$(Q)$(NASM) $(NASMFLAGS) -felf32 $(<) -o $(@)


$(BASE_DIR)/boot/kernel.o: $(BASE_DIR)/boot/kernel.c
	$(CC_PRINT)
	$(Q)$(CC) $(DEPFLAGS) $(CFLAGS) -c $(O_TO_C) -o $(@)


$(BASE_DIR)/boot/vga_print.o: $(BASE_DIR)/boot/vga_print.c
	$(CC_PRINT)
	$(Q)$(CC) $(DEPFLAGS) $(CFLAGS) -c $(O_TO_C) -o $(@)


$(BASE_DIR)/boot/idt.o: $(BASE_DIR)/boot/idt.c
	$(CC_PRINT)
	$(Q)$(CC) $(DEPFLAGS) $(CFLAGS) -c $(O_TO_C) -o $(@)


$(BASE_DIR)/boot/boot_fragments/01_gdt_entry.asm: $(BASE_DIR)/boot/boot_fragments/gen_gdt.c
	$(S)echo "Generating GDT..."
	$(Q)$(CC) -Wall -Wextra $(<) -o $(<:%.c=%)
	$(Q)$(<:%.c=%) > $(@)


$(BASE_DIR)/boot/boot.asm: $(BOOT_FRAGMENTS)
# Nop

$(BASE_DIR)/boot/boot.bin: $(BASE_DIR)/boot/boot.asm
	$(NASM_PRINT)
	$(Q)cd $(BASE_DIR)/boot && $(NASM) $(NASMFLAGS) -fbin $(<) -o $(@) && cd $(BASE_DIR);
