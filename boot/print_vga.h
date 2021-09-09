// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#ifndef BOOT__PRINT_VGA_H
#define BOOT__PRINT_VGA_H

#include <stdint.h>
#include <stddef.h>

#define VGA_WIDTH	80u
#define VGA_HEIGHT	20u

extern void vga_mem_init(void);
extern void vga_print(const char *str);

#endif /* #ifndef BOOT__PRINT_VGA_H */
