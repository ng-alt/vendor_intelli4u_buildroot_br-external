################################################################################
#
# samba
#
################################################################################

SAMBA_SITE = http://ftp.samba.org/pub/samba/stable
SAMBA_VERSION_FILE = source3/include/version.h
SAMBA_VERSION_PATTERN = "\#\s*define\s+SAMBA_VERSION_OFFICIAL_STRING\s+\"([^\"]+)\""

SAMBA_INSTALL_STAGING = NO
SAMBA_LICENSE = GPLv3+
SAMBA_LICENSE_FILES = COPYING
# Forcibly use one job to avoid dependency issues (include/proto.h)
SAMBA_MAKE = $(MAKE1)

SAMBA_PRE_BUILD_HOOKS += ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE
SAMBA_MAKE_OPTS = $(ROUTER_PREPARED_MAKE_OPTS)
SAMBA_INSTALL_TARGET_OPTS = $(SAMBA_MAKE_OPTS)

$(eval $(make-package))
