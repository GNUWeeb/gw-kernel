;
; SPDX-License-Identifier: GPL-2.0
;
; Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
;

gdt_descriptor:
	dw	__gdt_end - __gdt_start - 1
	dd	__gdt_start

end_of_code:
	times 510 - ($ - $$) db 0
	dw 0xaa55
