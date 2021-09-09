// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

struct GDT {
	uint32_t	base;
	uint32_t	limit;
	uint16_t	type;
};

void encode_gdt_entry(uint8_t *target, struct GDT source)
{
	// Check the limit to make sure that it can be encoded
	if ((source.limit > 65536) && ((source.limit & 0xFFF) != 0xFFF)) {
		printf("You can't do that! (Error GDT encode)\n");
		exit(1);
	}

	if (source.limit > 65536) {
		// Adjust granularity if required
		source.limit = source.limit >> 12;
		target[6] = 0xC0;
	} else {
		target[6] = 0x40;
	}

	// Encode the limit
	target[0] = source.limit & 0xFF;
	target[1] = (source.limit >> 8) & 0xFF;
	target[6] |= (source.limit >> 16) & 0xF;

	// Encode the base 
	target[2] = source.base & 0xFF;
	target[3] = (source.base >> 8) & 0xFF;
	target[4] = (source.base >> 16) & 0xFF;
	target[7] = (source.base >> 24) & 0xFF;

	// And... Type
	target[5] = source.type;
}

void print_gdt_raw(uint8_t gdt_raw[8])
{
	size_t i;
	for (i = 0; i < 8; i++)
		printf("\tdb\t%#0hhx\n", gdt_raw[i]);
}

int main(void)
{
	uint8_t gdt_raw[8];
	struct GDT gdt_array[10] = {
		{.base=0, .limit=0, .type=0},
		{.base=0, .limit=0xffffffff, .type=0x9A},
		{.base=0, .limit=0xffffffff, .type=0x92},

		// TODO: Add TSS GDT entry
		// {.base=&myTss, .limit=sizeof(myTss), .type=0x89}
	};

	puts(";");
	puts("; SPDX-License-Identifier: GPL-2.0");
	puts(";");
	puts("; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>");
	puts(";");

	printf("\n__gdt_start:\n");
	encode_gdt_entry(gdt_raw, gdt_array[0]);
	printf("gdt_null:\n");
	print_gdt_raw(gdt_raw);
	encode_gdt_entry(gdt_raw, gdt_array[1]);
	printf("gdt_code:\n");
	print_gdt_raw(gdt_raw);
	printf("gdt_data:\n");
	encode_gdt_entry(gdt_raw, gdt_array[2]);
	print_gdt_raw(gdt_raw);
	printf("__gdt_end:\n");
	return 0;
}
