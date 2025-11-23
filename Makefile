# Adapted Makefile for Buildroot External
# based on mkmakefile output
ifeq ("$(origin V)", "command line")
VERBOSE := $(V)
endif
ifneq ($(VERBOSE),1)
Q := @
endif

# path to Buildroot and output directory
BUILDROOT_DIR := $(CURDIR)/buildroot
OUTPUT_DIR := $(CURDIR)/output

# Verify Buildroot exists
ifeq (,$(wildcard $(BUILDROOT_DIR)/Makefile))
$(error BUILDROOT_DIR '$(BUILDROOT_DIR)' is missing or invalid)
endif

# Construct Make arguments
MAKEARGS := -C $(BUILDROOT_DIR)
MAKEARGS += O=$(OUTPUT_DIR)
MAKEARGS += BR2_EXTERNAL=$(CURDIR)

MAKEFLAGS += --no-print-directory

# Filter Makefile from goals (to avoid infinite loop)
all_targets := $(filter-out Makefile,$(MAKECMDGOALS))

.PHONY: _all

_all:
	$(Q)umask 0022 && $(MAKE) $(MAKEARGS) $(all_targets)

# Forward targets like `make menuconfig`, `make linux`, etc.
$(all_targets): _all
	@:

# Catch any directory-style targets like `foo/`
%/: _all
	@:
