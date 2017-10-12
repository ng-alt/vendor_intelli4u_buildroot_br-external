################################################################################
#
# lighttpd
#
################################################################################

LIGHTTPD_AUTOGEN = YES
LIGHTTPD_LICENSE = BSD-3-Clause
LIGHTTPD_LICENSE_FILES = COPYING
LIGHTTPD_DEPENDENCIES = host-pkgconf
LIGHTTPD_CONF_OPTS = \
	--libdir=/usr/lib/lighttpd \
	--libexecdir=/usr/lib

ifeq ($(BR2_PACKAGE_LIGHTTPD_OPENSSL),y)
LIGHTTPD_DEPENDENCIES += openssl
LIGHTTPD_CONF_OPTS += --with-openssl
else
LIGHTTPD_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_ZLIB),y)
LIGHTTPD_DEPENDENCIES += zlib
LIGHTTPD_CONF_OPTS += --with-zlib
else
LIGHTTPD_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_BZIP2),y)
LIGHTTPD_DEPENDENCIES += bzip2
LIGHTTPD_CONF_OPTS += --with-bzip2
else
LIGHTTPD_CONF_OPTS += --without-bzip2
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_PCRE),y)
LIGHTTPD_CONF_ENV = PCRECONFIG=$(STAGING_DIR)/usr/bin/pcre-config
LIGHTTPD_DEPENDENCIES += pcre
LIGHTTPD_CONF_OPTS += --with-pcre
else
LIGHTTPD_CONF_OPTS += --without-pcre
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_WEBDAV),y)
LIGHTTPD_DEPENDENCIES += libxml2 sqlite
LIGHTTPD_CONF_OPTS += --with-webdav-props
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
LIGHTTPD_CONF_OPTS += --with-webdav-locks
LIGHTTPD_DEPENDENCIES += util-linux
else
LIGHTTPD_CONF_OPTS += --without-webdav-locks
endif
else
LIGHTTPD_CONF_OPTS += --without-webdav-props --without-webdav-locks
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_SAMBA),y)
LIGHTTPD_DEPENDENCIES += libxml2 sqlite libsmbclient
# merlin extension has samba version limitation, refer the path strictly here
LIGHTTPD_CONF_OPTS += \
	--with-smbdav-locks \
	--with-smbdav-props \
	--with-libsmbclient=$(LIBSMBCLIENT_DIR)/source3
else
LIGHTTPD_CONF_OPTS += --without-smbdav-props
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_LUA),y)
LIGHTTPD_DEPENDENCIES += lua
LIGHTTPD_CONF_OPTS += --with-lua
else
LIGHTTPD_CONF_OPTS += --without-lua
endif

$(eval $(autotools-package))
