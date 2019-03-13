################################################################################
#
# quagga
#
################################################################################

QUAGGA_SITE = http://download.savannah.gnu.org/releases/quagga
QUAGGA_DEPENDENCIES = host-pkgconf
QUAGGA_LICENSE = GPL-2.0+
QUAGGA_LICENSE_FILES = COPYING

# We need to override the sysconf and localstate directories so that
# quagga can create files as the quagga user without extra
# intervention
QUAGGA_CONF_OPTS = \
	--program-transform-name='' \
	--sysconfdir=/etc/quagga \
	--localstatedir=/var/run/quagga

# 0002-configure-fix-static-linking-with-readline.patch
QUAGGA_AUTORECONF = YES

QUAGGA_CONF_OPTS += --disable-doc

ifeq ($(BR2_PACKAGE_LIBCAP),y)
QUAGGA_CONF_OPTS += --enable-capabilities
QUAGGA_DEPENDENCIES += libcap
else
QUAGGA_CONF_OPTS += --disable-capabilities
endif

ifeq ($(BR2_PACKAGE_PROTOBUF_C),y)
QUAGGA_CONF_OPTS += --enable-protobuf
QUAGGA_DEPENDENCIES += protobuf-c
else
QUAGGA_CONF_OPTS += --disable-protobuf
endif

QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_ZEBRA),--enable-zebra,--disable-zebra)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_BABELD),--enable-babeld,--disable-babeld)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_BGPD),--enable-bgpd,--disable-bgpd)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_RIPD),--enable-ripd,--disable-ripd)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_RIPNGD),--enable-ripngd,--disable-ripngd)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_OSPFD),--enable-ospfd,--disable-ospfd --disable-ospfapi)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_OSPF6D),--enable-ospf6d,--disable-ospf6d)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_OSPFCLIENT),--enable-ospfclient,--disable-ospfclient)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_PIMD),--enable-pimd,--disable-pimd)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_WATCHQUAGGA),--enable-watchquagga,--disable-watchquagga)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_ISISD),--enable-isisd,--disable-isisd)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_BGP_ANNOUNCE),--enable-bgp-announce,--disable-bgp-announce)
QUAGGA_CONF_OPTS += $(if $(BR2_PACKAGE_QUAGGA_TCP_ZERBRA),--enable-tcp-zebra,--disable-tcp-zebra)

ifeq ($(BR2_PACKAGE_QUAGGA_SNMP),y)
QUAGGA_CONF_ENV += ac_cv_path_NETSNMP_CONFIG=$(STAGING_DIR)/usr/bin/net-snmp-config
QUAGGA_CONF_OPTS += --enable-snmp=agentx
QUAGGA_DEPENDENCIES += netsnmp
endif

ifeq ($(BR2_PACKAGE_QUAGGA_VTYSH),y)
QUAGGA_CONF_OPTS += --enable-vtysh
QUAGGA_DEPENDENCIES += readline
else
QUAGGA_CONF_OPTS += --disable-vtysh
endif

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
QUAGGA_CONF_OPTS += --disable-pie
endif

$(eval $(autotools-package))
