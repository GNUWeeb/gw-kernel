;
; SPDX-License-Identifier: GPL-2.0
;
; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
;

__gdt_start:
gdt_null:
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0
	db	0x40
	db	0
gdt_code:
	db	0xff
	db	0xff
	db	0
	db	0
	db	0
	db	0x9a
	db	0xcf
	db	0
gdt_data:
	db	0xff
	db	0xff
	db	0
	db	0
	db	0
	db	0x92
	db	0xcf
	db	0
__gdt_end:
