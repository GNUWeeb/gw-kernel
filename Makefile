# SPDX-License-Identifier: GPL-2.0

HOSTCC := cc
HOSTLD := ld
HOSTCXX := cxx
MKFLAGS := --no-print-directory

all:
	+$(MAKE) $(MKFLAGS) -f boot/Makefile

clean:
	+$(MAKE) $(MKFLAGS) -f boot/Makefile clean

boot:
	+$(MAKE) $(MKFLAGS) -f boot/Makefile boot

.PHONY: all clean boot
