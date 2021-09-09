
.section .text
.global memset
.global memcpy

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

# void *memcpy(void *__restrict__ dst, const void *__restrict__ src, size_t len);
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
