// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#include "print_vga.h"
#include <gwk/string.h>

static volatile uint16_t vga_x_pos;
static volatile uint16_t vga_y_pos;
static volatile uint16_t (*video_mem)[VGA_WIDTH];


static inline uint16_t vga_make_char(uint8_t c, uint8_t color)
{
	return (color << 8u) | c;
}


static void vga_put_char(uint16_t x, uint16_t y, uint8_t c, uint8_t color)
{
	video_mem[y][x] = vga_make_char(c, color);
}


static void vga_write_char(uint8_t c, uint8_t color)
{
	if (c == '\n') {
		vga_x_pos = 0;
		vga_y_pos++;
		return;
	}

	vga_put_char(vga_x_pos, vga_y_pos, c, color);

	if (++vga_x_pos >= VGA_WIDTH) {
		vga_x_pos = 0;
		vga_y_pos++;
	}
}


void vga_mem_init(void)
{
	uint16_t x, y;

	vga_x_pos = 0;
	vga_x_pos = 0;
	video_mem = (volatile void *)0xb8000;

	for (y = 0; y < VGA_HEIGHT; y++) {
		for (x = 0; x < VGA_WIDTH; x++) {
			vga_put_char(x, y, ' ', 0);
		}
	}
}


void vga_print(const char *str)
{
	while (*str) {
		vga_write_char((uint8_t)*str, 15);
		str++;
	}
}
