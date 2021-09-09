// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#ifndef GWK__STRING_H
#define GWK__STRING_H

#include <stddef.h>
#include <stdint.h>

extern void *memset(void *p, int c, size_t len);
extern void *memcpy(void *__restrict__ dst, const void *__restrict__ src,
		    size_t len);
extern void *memmove(void *dst, const void *src, size_t len);

#endif /* #ifndef GWK__STRING_H */
