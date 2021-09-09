;
; SPDX-License-Identifier: GPL-2.0
;
; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
;

[BITS 32]

[section .text]

global _start
extern kernel_main

CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
	mov	ax, DATA_SEG
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	gs, ax
	mov	ss, ax

	; Enable A20 line.
	in	al, 0x92
	or	al, 0x2
	out	0x92, al

	; Remap the master PIC.
	mov	al, 0b00010001
	out	0x20, al	; Tell the master PIC.

	mov	al, 0x20	; Interrupt 0x20 is where the master ISR should start.
	out	0x21, al

	mov	al, 0b00000001
	out	0x21, al
	; End of remap the master PIC.

	xor	ebp, ebp
	mov	esp,  0x200000
	call	kernel_main

_end_loop:
	cli
	hlt
	jmp	_end_loop
