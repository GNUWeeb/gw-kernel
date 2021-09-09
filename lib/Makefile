# SPDX-License-Identifier: GPL-2.0
#
# Copyright (C) 2021  Ammar Faizi <ammarfaizi2@gmail.com>
#

DEP_DIRS += $(BASE_DEP_DIR)/lib

OBJ_PRE_CC += \
	$(BASE_DIR)/lib/string.o


$(BASE_DIR)/lib/string.o: $(BASE_DIR)/lib/string.S
	$(AS_PRINT)
	$(Q)$(CC) $(CFLAGS) -c $(<) -o $(@)
