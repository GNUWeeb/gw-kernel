
#include <gwk/string.h>

void *memset(void *p, int c, size_t len)
{
	void *orig = p;
	__asm__ volatile(
		"rep stosb"
		: "+D"(p), "+c"(len)
		: "a"(c)
		: "memory"
	);
	return orig;
}


void *memcpy(void *__restrict__ dst, const void *__restrict__ src, size_t len)
{
	void *orig = dst;
	__asm__ volatile(
		"rep movsb"
		: "+D"(dst), "+S"(src), "+c"(len)
		:
		: "memory"
	);
	return orig;
}
