################################################################################
#
# bftpd
#
################################################################################

BFTPD_SITE = http://bftpd.sourceforge.net/downloads/rpm
BFTPD_LICENSE = GPL-2.0
BFTPD_LICENSE_FILES = COPYING
BFTPD_DEPENDENCIES = openssl router
BFTPD_MAKE_OPTS = \
	CFLAGS="-I. -I$(OPENSSL_DIR)/include -I$(BR2_TOPDIR)$(ACOS)/include -I$(BR2_TOPDIR)$(SRCBASE)/include -DVERSION=\\\"$(BFTPD_VERSION)\\\"" \
	LDFLAGS="-L$(TARGET_DIR)/usr/lib -lnvram -lcrypto -L$(TARGET_DIR)/lib"
BFTPD_INSTALL_TARGET_OPTS = TARGETDIR=$(TARGET_DIR) install

BFTPD_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))
