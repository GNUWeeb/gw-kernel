#
# SPDX-License-Identifier: GPL-2.0-only
#
# @author Ammar Faizi <ammarfaizi2@gmail.com> https://www.facebook.com/ammarfaizi2
# @license GNU GPL-2.0-only
#
# Flag for compilers and linkers.
#


#
# Make sure our compilers have `__GNUC__` support
#
CC_BUILTIN_CONSTANTS	:= $(shell $(CC) -dM -E - < /dev/null)
CXX_BUILTIN_CONSTANTS	:= $(shell $(CXX) -dM -E - < /dev/null)
ifeq (,$(findstring __GNUC__,$(CC_BUILTIN_CONSTANTS)))
	CC := /bin/echo I want __GNUC__! && false
endif

ifeq (,$(findstring __GNUC__,$(CXX_BUILTIN_CONSTANTS)))
	CXX := /bin/echo I want __GNUC__! && false
endif


#
# Prepare warn flags for Clang or GCC.
#
ifneq (,$(findstring __clang__,$(CC_BUILTIN_CONSTANTS)))
	# It's clang
	WARN_FLAGS := $(CLANG_WARN_FLAGS)
else
	# It's pure GCC
	WARN_FLAGS := $(GCC_WARN_FLAGS)
endif


#
# Are warnings allowed?
#
ifeq ($(BAN_WARN),1)
	WARN_FLAGS := -Werror $(WARN_FLAGS)
endif


C_CXX_FLAGS += $(WARN_FLAGS)


#
# Release or debug?
#
ifeq ($(RELEASE_MODE),1)
	LDFLAGS		+= -O3
	C_CXX_FLAGS	+= -O3 $(C_CXX_FLAGS_RELEASE)
else
	LDFLAGS		+= $(DEFAULT_OPTIMIZATION)
	C_CXX_FLAGS	+= $(DEFAULT_OPTIMIZATION) $(C_CXX_FLAGS_DEBUG)

	#
	# Always sanitize debug build, unless otherwise specified.
	#
	ifndef SANITIZE
		SANITIZE = 1
	endif
endif


#
# File dependency generator (especially for headers)
#
DEPFLAGS = -MT "$@" -MMD -MP -MF "$(@:$(BASE_DIR)/%.o=$(BASE_DEP_DIR)/%.d)"

# Convert *.o filename to *.c
O_TO_C = $(@:$(BASE_DIR)/%.o=%.c)

CFLAGS = $(C_CXX_FLAGS) $(INCLUDE_DIR)
CXXFLAGS = $(C_CXX_FLAGS) $(INCLUDE_DIR)
