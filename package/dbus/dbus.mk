################################################################################
#
# dbus
#
################################################################################

DBUS_SITE = https://dbus.freedesktop.org/releases/dbus
DBUS_AUTORECONF = YES
DBUS_LICENSE = AFL-2.1 or GPL-2.0+ (library, tools), GPL-2.0+ (tools)
DBUS_LICENSE_FILES = COPYING
DBUS_INSTALL_STAGING = YES

DBUS_DEPENDENCIES = host-pkgconf expat

DBUS_CONF_ENV = ac_cv_have_abstract_sockets=yes
DBUS_CONF_OPTS = \
	--with-dbus-user=dbus \
	--disable-tests \
	--disable-asserts \
	--enable-abstract-sockets \
	--disable-selinux \
	--enable-xml-docs \
	--disable-doxygen-docs \
	--disable-dnotify \
	--with-xml=expat \
	--with-system-socket=/var/run/dbus/system_bus_socket \
	--with-system-pid-file=/var/run/messagebus.pid \
	--with-init-scripts=none

ifeq ($(BR2_STATIC_LIBS),y)
DBUS_CONF_OPTS += LIBS='-pthread'
endif

ifeq ($(BR2_microblaze),y)
# microblaze toolchain doesn't provide inotify_rm_* but does have sys/inotify.h
DBUS_CONF_OPTS += --disable-inotify
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
DBUS_CONF_OPTS += --enable-selinux
DBUS_DEPENDENCIES += libselinux
else
DBUS_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_AUDIT)$(BR2_PACKAGE_LIBCAP_NG),yy)
DBUS_CONF_OPTS += --enable-libaudit
DBUS_DEPENDENCIES += audit libcap-ng
else
DBUS_CONF_OPTS += --disable-libaudit
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
DBUS_CONF_OPTS += --with-x
DBUS_DEPENDENCIES += xlib_libX11
ifeq ($(BR2_PACKAGE_XLIB_LIBSM),y)
DBUS_DEPENDENCIES += xlib_libSM
endif
else
DBUS_CONF_OPTS += --without-x
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
DBUS_CONF_OPTS += \
	--enable-systemd \
	--with-systemdsystemunitdir=/usr/lib/systemd/system
DBUS_DEPENDENCIES += systemd
else
DBUS_CONF_OPTS += --disable-systemd
endif

define DBUS_REMOVE_DEVFILES
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
endef

define DBUS_REMOVE_UNNEEDED_FILES
	$(SED) 's/SUBDIRS=dbus bus tools test doc/SUBDIRS=dbus bus/g' $(@D)/Makefile.am
endef

DBUS_PRE_CONFIGURE_HOOKS += DBUS_REMOVE_UNNEEDED_FILES

# fix rebuild (dbus makefile errors out if /var/lib/dbus is a symlink)
define DBUS_REMOVE_VAR_LIB_DBUS
	rm -rf $(TARGET_DIR)/var/lib/dbus
endef

DBUS_PRE_INSTALL_TARGET_HOOKS += DBUS_REMOVE_VAR_LIB_DBUS

#define DBUS_REMOVE_DEVFILES
#	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
#endef
#
#DBUS_POST_INSTALL_TARGET_HOOKS += DBUS_REMOVE_DEVFILES

$(eval $(autotools-package))
