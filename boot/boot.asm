;
; SPDX-License-Identifier: GPL-2.0
;
; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
;

[org 0x7c00]
[BITS 16]

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

__start:
	jmp	short _start
	nop
	times 33 db 0
_start:
	jmp	0x0:start
start:
	cli
	xor	ax, ax
	mov	ds, ax
	mov	es, ax

	xor	ax, ax
	mov	ss, ax
	mov	sp, 0x7c00
	sti

.load_protected:
	cli
	lgdt	[gdt_descriptor]
	; Whee, we are entering the protected mode!
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	jmp	CODE_SEG:load32


; GDT
gdt_start:

gdt_null:
	dd	0x0
	dd	0x0
	; Offset 0x8
gdt_code:			; CS should point to this label.
	dw	0xffff		; Segment limit first 0-15 bit.
	dw	0x0		; Base first 0-15 bits.
	db	0x0		; Base 16-23 bits.
	db	0x9a		; Access byte.
	db	11001111b	; High 4 bit flags and low 4 bit flags.
	db	0x0		; Base 24-31 bits.
	; Offset 0x10

gdt_data:			; DS, SS, ES, FS, GS
	dw	0xffff		; Segment limit first 0-15 bit.
	dw	0x0		; Base first 0-15 bits.
	db	0x0		; Base 16-23 bits.
	db	0x92		; Access byte.
	db	11001111b	; High 4 bit flags and low 4 bit flags.
	db	0x0		; Base 24-31 bits.
gdt_end:

gdt_descriptor:
	dw	gdt_end - gdt_start - 1
	dd	gdt_start

[BITS 32]
load32:
.end:
	cli
.end_loop:
	hlt
	jmp	.end_loop


end_of_code:
	times 510 - ($ - $$) db 0
	dw 0xaa55
