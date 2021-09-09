// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#ifndef GWK__IO_H
#define GWK__IO_H

#include <stddef.h>
#include <stdint.h>

#include <gwk/common.h>


static __always_inline u8 inb(u16 port)
{
	u8 al = 0;
	__asm__ volatile(
		"inb\t%1, %0"
		: "+a"(al)
		: "d"(port)
		: "memory"
	);
	return al;
}


static __always_inline u16 inw(u16 port)
{
	u16 ax = 0;
	__asm__ volatile(
		"inw\t%1, %0"
		: "+a"(ax)
		: "d"(port)
		: "memory"
	);
	return ax;
}


static __always_inline u16 inl(u16 port)
{
	u16 eax = 0;
	__asm__ volatile(
		"inl\t%1, %0"
		: "+a"(eax)
		: "d"(port)
		: "memory"
	);
	return eax;
}


static __always_inline void outb(u16 port, u8 val)
{
	__asm__ volatile(
		"outb\t%0,\t%1"
		:
		: "a"(val), "d"(port)
		: "memory"
	);
}


static __always_inline void outw(u16 port, u8 val)
{
	__asm__ volatile(
		"outw\t%0,\t%1"
		:
		: "a"(val), "d"(port)
		: "memory"
	);
}


static __always_inline void outl(u16 port, u8 val)
{
	__asm__ volatile(
		"outl\t%0,\t%1"
		:
		: "a"(val), "d"(port)
		: "memory"
	);
}


#endif /* #ifndef GWK__IO_H */
