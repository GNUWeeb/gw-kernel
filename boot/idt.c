// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#include "idt.h"
#include "vga_print.h"
#include <gwk/string.h>


struct idt_desc idt_descriptors[GWK_TOTAL_INTERRUPTS];
struct idtr_desc idtr_descriptor;


static __always_inline void idt_load(register struct idtr_desc *addr)
{
	__asm__ volatile("lidt (%0)":"+b"(addr) :: "memory");
}


__idt_func void int21_handler(struct intr_frame *frame)
{
	vga_print("Keyboard interrupt!");
}


void idt_set(uint16_t int_no, void *addr)
{
	struct idt_desc *desc = &idt_descriptors[int_no];

	desc->offset_1 = (uint16_t)((uint32_t)addr & 0x0000ffff);
	desc->selector = KERNEL_CODE_SELECTOR;
	desc->zero = 0x00;
	desc->type_attr = 0xee;
	desc->offset_2 = (uint16_t)((uint32_t)addr >> 16u);
}


void idt_init(void)
{
	memset(idt_descriptors, 0, sizeof(idt_descriptors));
	idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
	idtr_descriptor.base = (uint32_t)idt_descriptors;
	// idt_set(0x21, int21_handler);
	idt_load(&idtr_descriptor);
}
