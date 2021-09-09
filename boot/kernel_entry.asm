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
	xor	ebp, ebp
	mov	esp,  0x00200000
	cli

	;
	; Enable the A20 line
	; Ref: https://wiki.osdev.org/A20_Line
	;
	in	al, 0x92
	or	al, 0x2
	out	0x92, al

	call	kernel_main

_end_loop:
	hlt
	jmp	_end_loop
