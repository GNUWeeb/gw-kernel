// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#include "kernel.h"
#include "print_vga.h"


void kernel_main(void)
{
	vga_mem_init();
	vga_print("Hello World!");
}
