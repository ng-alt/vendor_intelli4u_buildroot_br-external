################################################################################
#
# openvpn
#
################################################################################

OPENVPN_VERSION_FILE = version.m4
OPENVPN_VERSION_PATTERN = "@(PRODUCT_VERSION_MAJOR).@(PRODUCT_VERSION_MINOR)@(PRODUCT_VERSION_PATCH)"
OPENVPN_SITE = http://swupdate.openvpn.net/community/releases
OPENVPN_DEPENDENCIES = host-pkgconf openssl
OPENVPN_AUTORECONF = YES
OPENVPN_LICENSE = GPL-2.0
OPENVPN_LICENSE_FILES = COPYRIGHT.GPL

OPENVPN_CONF_OPTS = \
	--disable-debug \
	--enable-management \
	--disable-selinux \
	--disable-socks \
	--enable-plugin-auth-pam \
	--enable-iproute2 \
	ac_cv_lib_resolv_gethostbyname=no

ifeq ($(BR2_PACKAGE_OPENVPN_SMALL),y)
OPENVPN_CONF_OPTS += \
	--enable-small \
	--disable-plugins
endif

# BusyBox 1.21+ places the ip applet in the "correct" place
# but previous versions didn't.
ifeq ($(BR2_PACKAGE_IPROUTE2),y)
OPENVPN_CONF_ENV += IPROUTE=/sbin/ip
else ifeq ($(BR2_BUSYBOX_VERSION_1_19_X)$(BR2_BUSYBOX_VERSION_1_20_X),y)
OPENVPN_CONF_ENV += IPROUTE=/bin/ip
else
OPENVPN_CONF_ENV += IPROUTE=/sbin/ip
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZ4),y)
OPENVPN_DEPENDENCIES += lz4
else
OPENVPN_CONF_OPTS += --disable-lz4
endif

ifeq ($(BR2_PACKAGE_OPENVPN_LZO),y)
OPENVPN_DEPENDENCIES += lzo
else
OPENVPN_CONF_OPTS += --disable-lzo
endif

define OPENVPN_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/src/openvpn/openvpn $(TARGET_DIR)/usr/sbin/openvpn
endef

$(eval $(autotools-package))
