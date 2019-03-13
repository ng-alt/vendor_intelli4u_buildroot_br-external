################################################################################
#
# wget
#
################################################################################

WGET_SITE = $(BR2_GNU_MIRROR)/wget
WGET_AUTOGEN = YES
WGET_AUTOGEN_OPTS = --no-git --skip-po --gnulib-srcdir=$(BR2_TOPDIR)/external/gnulib
WGET_DEPENDENCIES = host-pkgconf
WGET_LICENSE = GPL-3.0+
WGET_LICENSE_FILES = COPYING

# Prefer full-blown wget over busybox
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
WGET_DEPENDENCIES += busybox
endif

# Install to / instead of the default /usr
WGET_CONF_OPTS += --prefix=/ --exec-prefix=/
ifeq ($(BR2_PACKAGE_GNUTLS),y)
WGET_CONF_OPTS += --with-ssl=gnutls
WGET_DEPENDENCIES += gnutls
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
WGET_CONF_OPTS += --with-ssl=openssl
WGET_DEPENDENCIES += openssl
else
WGET_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
WGET_DEPENDENCIES += util-linux
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
WGET_CONF_OPTS += --with-zlib
WGET_DEPENDENCIES += zlib
else
WGET_CONF_OPTS += --without-zlib
endif

define WGET_DISABLE_BUILD
	$(SED) 's, doc , ,' $(@D)/Makefile.am
endef
WGET_PRE_CONFIGURE_HOOKS += WGET_DISABLE_BUILD

define WGET_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/wget $(TARGET_DIR)/usr/sbin/
endef

$(eval $(autotools-package))
