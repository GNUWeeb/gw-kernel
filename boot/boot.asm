;
; SPDX-License-Identifier: GPL-2.0
;
; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
;

[org 0]
BITS 16

__start:
	jmp	short _start
	nop
	times 33 db 0
_start:
	jmp	0x7c0:start

int_0:
	xor	bx, bx
	mov	ah, 0xe
	mov	al, 'A'
	int	0x10
	iret

int_1:
	xor	bx, bx
	mov	ah, 0xe
	mov	al, 'V'
	int	0x10
	iret

start:
	cli
	mov	ax, 0x7c0
	mov	ds, ax
	mov	es, ax

	xor	ax, ax
	mov	ss, ax
	mov	sp, 0x7c00
	sti

	mov	word [ss:0x00], int_0
	mov	word [ss:0x02], 0x7c0
	mov	word [ss:0x00], int_1
	mov	word [ss:0x02], 0x7c0

	; Call routine based on interrupt vector table 0x1
	int	0x1

	; Call routine based on interrupt vector table 0x0 (exception division by zero)
	mov	ax, 0
	div	ax

	mov	si, msg
	call	print
	cli
end:
	hlt
	jmp	end


print:
	xor	bx, bx
.pr_loop:
	lodsb
	test	al, al
	jz	.done
	mov	ah, 0xe
	int	0x10
	jmp	.pr_loop
.done:
	ret

msg:
	db "Hello World!", 0
	times 510 - ($ - $$) db 0
	dw 0xaa55
