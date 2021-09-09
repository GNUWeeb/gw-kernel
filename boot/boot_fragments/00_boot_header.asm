;
; SPDX-License-Identifier: GPL-2.0
;
; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
;

[org 0x7c00]
[bits 16]

CODE_SEG	equ	gdt_code - __gdt_start
DATA_SEG	equ	gdt_data - __gdt_start

__boot:
	jmp	short _boot
	nop
_boot:
	jmp	0x0:boot
boot:
	cli		; Clear interrupt flag
	mov	ax, 0x00
	mov	ds, ax
	mov	es, ax
	mov	ss, ax
	mov	sp, 0x7c00


enter_protected_mode:
	lgdt	[gdt_descriptor]
	mov	eax, cr0
	or	eax, 1
	mov	cr0, eax
	jmp	CODE_SEG:load32


[BITS 32]
load32:
	mov	eax, 1
	mov	ecx, 100
	mov	edi, 0x100000
	call	ata_lba_read
	jmp	CODE_SEG:0x100000

ata_lba_read:
	mov	ebx, eax	; Backup the LBA

	; Send the highest 8 bits of the lba to hard disk controller
	shr	eax, 24
	or	eax, 0xE0	; Select the  master drive
	mov	dx, 0x1F6
	out	dx, al
	; Finished sending the highest 8 bits of the lba

	; Send the total sectors to read
	mov	eax, ecx
	mov	dx, 0x1F2
	out	dx, al
	; Finished sending the total sectors to read

	; Send more bits of the LBA
	mov	eax, ebx	; Restore the backup LBA
	mov	dx, 0x1F3
	out	dx, al
	; Finished sending more bits of the LBA

	; Send more bits of the LBA
	mov	dx, 0x1F4
	mov	eax, ebx	; Restore the backup LBA
	shr	eax, 8
	out	dx, al
	; Finished sending more bits of the LBA

	; Send upper 16 bits of the LBA
	mov	dx, 0x1F5
	mov	eax, ebx	; Restore the backup LBA
	shr	eax, 16
	out	dx, al
	; Finished sending upper 16 bits of the LBA

	mov	dx, 0x1f7
	mov	al, 0x20
	out	dx, al

	; Read all sectors into memory
.next_sector:
	push	ecx

	; Checking if we need to read
.try_again:
	mov	dx, 0x1f7
	in	al, dx
	test	al, 8
	jz .try_again

	; We need to read 256 words at a time
	mov	ecx, 256
	mov	dx, 0x1F0
	rep	insw
	pop	ecx
	loop	.next_sector
	; End of reading sectors into memory
	ret
