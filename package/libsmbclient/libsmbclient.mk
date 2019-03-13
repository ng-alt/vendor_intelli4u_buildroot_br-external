################################################################################
#
# libsmbclient
#
################################################################################

LIBSMBCLIENT_SITE = http://ftp.samba.org/pub/samba/stable
LIBSMBCLIENT_VERSION_FILE = source3/include/version.h
LIBSMBCLIENT_VERSION_PATTERN = "\#\s*define\s+SAMBA_VERSION_OFFICIAL_STRING\s+\"([^\"]+)\""

LIBSMBCLIENT_INSTALL_STAGING = NO
LIBSMBCLIENT_LICENSE = GPLv3+
LIBSMBCLIENT_LICENSE_FILES = COPYING

# Forcibly use one job to avoid dependency issues (include/proto.h)
LIBSMBCLIENT_MAKE = $(MAKE1)

LIBSMBCLIENT_PRE_BUILD_HOOKS += ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE
LIBSMBCLIENT_MAKE_OPTS = $(ROUTER_PREPARED_MAKE_OPTS)

define LIBSMBCLIENT_INSTALL_TARGET_CMDS
	install -D $(@D)/source3/bin/libsmbclient.so $(TARGET_DIR)/usr/lib/libsmbclient.so
endef

$(eval $(make-package))
