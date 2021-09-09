// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

.section .text
.global memset
.global memcpy
.global memmove

# void *memset(void *p, int c, size_t len);
memset:
	pushl	%edi
	movl	4(%esp), %edi
	movl	8(%esp), %eax
	movl	12(%esp), %ecx
	pushl	%edi
	rep	stosb
	popl	%eax
	popl	%edi
	ret

# void *memmove(void *dst, const void *src, size_t len);
# void *memcpy(void *__restrict__ dst, const void *__restrict__ src, size_t len);
memmove:
memcpy:
	pushl	%edi
	pushl	%esi
	movl	4(%esp), %edi
	movl	8(%esp), %esi
	movl	12(%esp), %ecx
	pushl	%edi
	rep	movsb
	popl	%eax
	popl	%esi
	popl	%edi
	ret
