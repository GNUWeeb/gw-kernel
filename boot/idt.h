// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#ifndef BOOT__IDT_H
#define BOOT__IDT_H

#include "config.h"
#include <gwk/common.h>

struct idt_desc {
	uint16_t	offset_1;
	uint16_t	selector;
	uint8_t		zero;
	uint8_t		type_attr;
	uint16_t	offset_2;
} __packed;


struct idtr_desc {
	uint16_t	limit;
	uint32_t	base;
} __packed;


struct intr_frame {
	uword_t ip;
	uword_t cs;
	uword_t flags;
	uword_t sp;
	uword_t ss;
};


extern struct idt_desc idt_descriptors[GWK_TOTAL_INTERRUPTS];
extern struct idtr_desc idtr_descriptor;

extern void idt_set(uint16_t int_no, void *addr);
extern void idt_init(void);

__idt_func void int21_handler(struct intr_frame *frame);

#endif /* #ifndef BOOT__IDT_H */