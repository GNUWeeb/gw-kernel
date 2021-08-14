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
start:
	cli
	mov	ax, 0x7c0
	mov	ds, ax
	mov	es, ax

	xor	ax, ax
	mov	ss, ax
	mov	sp, 0x7c00
	sti

	mov	si, msg
	call	print
	cli
end:
	hlt
	jmp	end


print:
	mov	bx, 0
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
