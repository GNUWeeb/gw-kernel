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

	; [int 0x13]
	;
	; DISK - READ SECTOR(S) INTO MEMORY
	;
	; AH = 02h
	; AL = number of sectors to read (must be nonzero)
	; CH = low eight bits of cylinder number
	; CL = sector number 1-63 (bits 0-5)
	; high two bits of cylinder (bits 6-7, hard disk only)
	; DH = head number
	; DL = drive number (bit 7 set for hard disk)
	; ES:BX -> data buffer

	; Return:
	; CF set on error
	; if AH = 11h (corrected ECC error), AL = burst length
	; CF clear if successful
	; AH = status (see #00234)
	; AL = number of sectors transferred (only valid if CF set for some BIOSes)
	;
	; Ref: http://www.ctyme.com/intr/rb-0607.htm
	;

	mov	ah, 0x2		; READ SECTOR command.
	mov	al, 0x1 	; Read 1 sector.
	xor	ch, ch 		; Cylinder number.
	mov	cl, 2		; The sector number to be read.
	xor	dh, dh		; Head number.
				; dl has already been set by BIOS.
	mov	bx, buffer	; Load the buffer.
	int	0x13
	jc	.disk_error	; If error, CF (Carry Flag) is set.

	mov	si, buffer
	call	print_str
	jmp	.end

.disk_error:
	mov	si, disk_err_msg
	call	print_str


.end:
	cli
.end_loop:
	hlt
	jmp	.end_loop


; print_str(const char *si);
print_str:
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

disk_err_msg:
	db "Error: Failed to load sector!", 0

end_of_code:
	times 510 - ($ - $$) db 0
	dw 0xaa55

buffer:
	; The content buffer will be here.

