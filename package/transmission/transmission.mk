################################################################################
#
# transmission
#
################################################################################

TRANSMISSION_SITE = https://github.com/transmission/transmission-releases/raw/master
TRANSMISSION_DEPENDENCIES = \
	host-pkgconf \
	host-intltool \
	libcurl \
	libevent \
	openssl \
	zlib
TRANSMISSION_AUTOGEN = YES
TRANSMISSION_AUTORECONF_ENV = AUTOGEN_SUBDIR_MODE=no
TRANSMISSION_CONF_OPTS = \
	--disable-libnotify \
	--enable-lightweight \
	--disable-silent-rules

TRANSMISSION_LICENSE = GPL-2.0 or GPL-3.0 with OpenSSL exception
TRANSMISSION_LICENSE_FILES = COPYING

define TRANSMISSION_REMOVE_ICONV
    $(SED) 's,iconv_open,,g' \$(@D)/configure.ac
endef
TRANSMISSION_PRE_CONFIGURE_HOOKS += TRANSMISSION_REMOVE_ICONV

ifeq ($(BR2_PACKAGE_LIBMINIUPNPC),y)
TRANSMISSION_DEPENDENCIES += libminiupnpc
endif

ifeq ($(BR2_PACKAGE_LIBNATPMP),y)
TRANSMISSION_DEPENDENCIES += libnatpmp
TRANSMISSION_CONF_OPTS += --enable-external-natpmp
else
TRANSMISSION_CONF_OPTS += --disable-external-natpmp
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_UTP),y)
TRANSMISSION_CONF_OPTS += --enable-utp
else
TRANSMISSION_CONF_OPTS += --disable-utp
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_CLI),y)
TRANSMISSION_CONF_OPTS += --enable-cli
else
TRANSMISSION_CONF_OPTS += --disable-cli
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_DAEMON),y)
TRANSMISSION_CONF_OPTS += --enable-daemon

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
TRANSMISSION_DEPENDENCIES += systemd
TRANSMISSION_CONF_OPTS += --with-systemd-daemon
else
TRANSMISSION_CONF_OPTS += --without-systemd-daemon
endif

define TRANSMISSION_USERS
	transmission -1 transmission -1 * /var/lib/transmission - transmission Transmission Daemon
endef

else
TRANSMISSION_CONF_OPTS += --disable-daemon
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_REMOTE),y)
TRANSMISSION_CONF_OPTS += --enable-remote
else
TRANSMISSION_CONF_OPTS += --disable-remote
endif

ifeq ($(BR2_PACKAGE_TRANSMISSION_GTK),y)
TRANSMISSION_CONF_OPTS += --with-gtk
TRANSMISSION_DEPENDENCIES += libgtk3
else
TRANSMISSION_CONF_OPTS += --without-gtk
endif

$(eval $(autotools-package))
