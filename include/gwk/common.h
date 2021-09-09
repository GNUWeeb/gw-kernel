// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
 */

#ifndef GWK__COMMON_H
#define GWK__COMMON_H

#include <stddef.h>
#include <stdint.h>

#ifdef __x86_64__
typedef unsigned long long int uword_t;
#else
typedef unsigned int uword_t;
#endif

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
typedef int8_t s8;
typedef int16_t s16;
typedef int32_t s32;
typedef int64_t s64;

#ifndef __packed
#  define __packed __attribute__((packed))
#endif

#ifndef __inline
#  define __inline inline
#endif

#ifndef __always_inline
#  define __always_inline __attribute__((always_inline)) __inline
#endif

#ifndef __no_inline
#  define __no_inline __attribute__((no_inline))
#endif

#ifndef __idt_func
#  define __idt_func __attribute__((interrupt,no_caller_saved_registers))
#endif

#endif /* #ifndef GWK__COMMON_H */
