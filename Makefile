# SPDX-License-Identifier: GPL-2.0

MKFLAGS = --no-print-directory

all:
	+$(MAKE) $(MKFLAGS) -C boot/

clean:
	+$(MAKE) $(MKFLAGS) -C boot/ clean	

boot:
	+$(MAKE) $(MKFLAGS) -C boot/ boot

.PHONY: all clean boot
