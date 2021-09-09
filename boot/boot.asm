;
; SPDX-License-Identifier: GPL-2.0
;
; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
;

[org 0x7c00]
[bits 16]

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

__boot:
	jmp	short _boot
	nop
	times 33 db 0x90
_boot:
	jmp	0x0:boot
boot:
	cli
	xor	ax, ax
	mov	ds, ax
	mov	es, ax

	xor	ax, ax
	mov	ss, ax
	mov	sp, 0x7c00

	call	check_a20
	test	ax, ax
	jnz	enter_protected_mode

	mov	di, str1
	call	print
	jmp	do_halt
str1:
	db	"A20 is disabled!", 0


print:
	pushf
	cli
	pusha
	mov	ah, 0x0e ; TTY mode
.pr_loop:
	mov	al, [di]
	test	al, al
	jz	.pr_ret

	int	0x10

	inc	di
	jmp	.pr_loop
.pr_ret:
	popa
	sti
	popf
	ret

do_halt:
	hlt
	jmp	do_halt

[bits 16]
; Function: check_a20
;
; Purpose: To check the status of the a20 line in a completely
;          self-contained state-preserving way. The function can be
;          modified as necessary by removing push's at the beginning and
;          their respective pop's at the end if complete self-containment
;          is not required.
;
; Returns: 0 in ax if the a20 line is disabled (memory wraps around)
;          1 in ax if the a20 line is enabled (memory does not wrap around)
;
; Link: https://wiki.osdev.org/A20_Line
;
check_a20:
	pushf
	push	ds
	push	es
	push	di
	push	si
	cli
	xor	ax, ax	; ax = 0
	mov	es, ax
	not	ax	; ax = 0xFFFF
	mov	ds, ax
	mov	di, 0x0500
	mov	si, 0x0510
	mov	al, byte [es:di]
	push	ax
	mov	al, byte [ds:si]
	push	ax
	mov	byte [es:di], 0x00
	mov	byte [ds:si], 0xFF
	cmp	byte [es:di], 0xFF
	pop	ax
	mov	byte [ds:si], al
	pop	ax
	mov	byte [es:di], al
	mov	ax, 0
	je	check_a20__exit
	mov	ax, 1
check_a20__exit:
	pop	si
	pop	di
	pop	es
	pop	ds
	popf
	ret


enter_protected_mode:
	; We are entering the protected mode!
	lgdt	[gdt_descriptor]
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
	mov	eax, 1
	mov	ecx, 100
	mov	edi, 0x100000
	call	ata_lba_read
	jmp	CODE_SEG:0x0100000

;
;=============================================================================
; ATA read sectors (LBA mode) 
;
; @param EAX Logical Block Address of sector
; @param CL  Number of sectors to read
; @param RDI The address of buffer to put data obtained from disk
;
; @return None
;=============================================================================
; Ref: https://wiki.osdev.org/ATA_read/write_sectors
;
ata_lba_read:
	pushfd
	and	eax, 0x0FFFFFFF
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	edi

	mov	ebx, eax	; Save LBA in EBX
	mov	edx, 0x01f6	; Port to send drive and bit 24 - 27 of LBA
	shr	eax, 24		; Get bit 24 - 27 in al
	or	al, 11100000b	; Set bit 6 in al for LBA mode
	out	dx, al

	mov	edx, 0x01f2	; Port to send number of sectors
	mov	al, cl		; Get number of sectors from CL
	out	dx, al

	mov	edx, 0x1f3	; Port to send bit 0 - 7 of LBA
	mov	eax, ebx	; Get LBA from EBX
	out	dx, al

	mov	edx, 0x1f4	; Port to send bit 8 - 15 of LBA
	mov	eax, ebx	; Get LBA from EBX
	shr	eax, 8		; Get bit 8 - 15 in AL
	out	dx, al

	mov	edx, 0x1f5	; Port to send bit 16 - 23 of LBA
	mov	eax, ebx	; Get LBA from EBX
	shr	eax, 16		; Get bit 16 - 23 in AL
	out	dx, al

	mov	edx, 0x1f7	; Command port
	mov	al, 0x20	; Read with retry.
	out	dx, al
.still_going:
	in	al, dx
	test	al, 8		; the sector buffer requires servicing.
	jz	.still_going	; until the sector buffer is ready.

	mov	eax, 256	; to read 256 words = 1 sector
	xor	bx, bx
	mov	bl, cl		; read CL sectors
	mul	bx
	mov	ecx, eax	; ecx is counter for INSW
	mov	edx, 0x1f0	; Data port, in and out
	rep	insw		; in to [edi]

	pop	edi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	popfd
	ret

end_of_code:
	times 510 - ($ - $$) db 0
	dw 0xaa55
