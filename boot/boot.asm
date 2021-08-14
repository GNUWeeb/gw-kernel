
[org 0x7c00]
BITS 16

start:
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
