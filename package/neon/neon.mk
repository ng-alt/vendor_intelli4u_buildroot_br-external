################################################################################
#
# neon
#
################################################################################

NEON_SITE = http://www.webdav.org/neon
NEON_VERSION_FILE = macros/neon.m4
NEON_VERSION_PATTERN = "@(NE_VERSION_MAJOR).@(NE_VERSION_MINOR)@(NE_VERSION_PATCH)"
NEON_LICENSE = LGPL-2.0+ (library), GPL-2.0+ (manual and tests)
NEON_LICENSE_FILES = src/COPYING.LIB test/COPYING README
NEON_AUTOGEN = YES
# NEON_INSTALL_STAGING = YES
NEON_CONF_OPTS = --without-gssapi --disable-rpath
NEON_CONFIG_SCRIPTS = neon-config
NEON_DEPENDENCIES = host-pkgconf

ifeq ($(BR2_PACKAGE_NEON_ZLIB),y)
NEON_CONF_OPTS += --with-zlib=$(STAGING_DIR)
NEON_DEPENDENCIES += zlib
else
NEON_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_NEON_SSL),y)
NEON_CONF_OPTS += --with-ssl
NEON_DEPENDENCIES += openssl
else
NEON_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_NEON_EXPAT),y)
NEON_CONF_OPTS += --with-expat=yes
NEON_DEPENDENCIES += expat
else
NEON_CONF_OPTS += --with-expat=no
endif

ifeq ($(BR2_PACKAGE_NEON_LIBXML2),y)
NEON_CONF_OPTS += --with-libxml2=yes
NEON_CONF_ENV += ac_cv_prog_XML2_CONFIG=$(STAGING_DIR)/usr/bin/xml2-config
NEON_DEPENDENCIES += libxml2
else
NEON_CONF_OPTS += --with-libxml2=no
endif

ifeq ($(BR2_PACKAGE_NEON_EXPAT)$(BR2_PACKAGE_NEON_LIBXML2),)
# webdav needs xml support
NEON_CONF_OPTS += --disable-webdav
endif

#- FIXME: use a script to generate the version file
define NENO_GENERATE_VERSION_FILE
	echo 0.29.6 > $(@D)/.version
endef
NENO_PRE_CONFIGURE_HOOKS = NENO_GENERATE_VERSION_FILE

define NEON_INSTALL_STAGING_CMDS
	$(HOST_MAKE_ENV) \
		$(MAKE) DESTDIR=$(STAGING_DIR) -C $(@D) install-lib
endef

define NEON_INSTALL_TARGET_CMDS
	$(HOST_MAKE_ENV) \
		$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install-lib
endef

$(eval $(autotools-package))
