// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#include "idt.h"
#include "kernel.h"
#include "print_vga.h"
#include <gwk/io.h>

void kernel_main(void)
{
	vga_mem_init();
	idt_init();
	vga_print("Starting GNU/Weeb Kernel...\n");
	vga_print("Loading IDT...\n");
	vga_print("\nHi, this is a test writing to VGA memory from 32-bit protected mode\n");
	vga_print("\nSigned-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>\n");
}
