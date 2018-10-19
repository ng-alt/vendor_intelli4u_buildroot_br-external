################################################################################
#
# router
#
################################################################################

ROUTER_VERSION_FILE = $(BR2_TOPDIR)vendor/netgear/acos/include/ambitCfg.h
ROUTER_VERSION_PATTERN = "\#\s*define\s+AMBIT_SOFTWARE_VERSION\s+\"([^\"]+)\""
ROUTER_SITE = https://www.downloads.netgear.com/files/GPL
ROUTER_SOURCE = R6300v2-$(ROUTER_VERSION)_src.tar.zip
ROUTER_LICENSE = GPL-2.0
ROUTER_LICENSE_FILES = LICENSE
ROUTER_BUILD_CONFIG = $(ROUTER_DIR)/.config

ROUTER_MAKE = $(MAKE1)
ROUTER_MAKE_OPTS = \
	CROSS_COMPILE=$(patsubst %-gcc,%-,$(notdir $(TARGET_CC))) \
	SRCBASE="$(ROOTDIR)$(SRCBASE)" \
	TOP="$(ROUTER_DIR)" ROUTER_DIR="$(ROUTER_DIR)" \
	IPTABLESDIR="$(IPTABLES_DIR)" \
	OPENSSLDIR="$(OPENSSL_DIR)" \
	ZLIBDIR="$(ZLIB_DIR)" \
	BUSYBOX_OUTDIR="$(BUSYBOX_DIR)" BUSYBOXDIR="$(if $(BUSYBOX_OVERRIDE2_SRCDIR),$(BUSYBOX_OVERRIDE2_SRCDIR),$(BUSYBOX_DIR))" \
	LINUX_DIR="$(LINUX_DIR)" LINUX_OUTDIR="$(LINUX_DIR)" LINUXDIR=$(if $(LINUX_OVERRIDE2_SRCDIR),$(LINUX_OVERRIDE2_SRCDIR),$(LINUX_DIR))

ROUTER_VENDOR = $(call qstrip,$(BR2_PACKAGE_ROUTER_VENDOR))
ROUTER_KCONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_ROUTER_CONFIG))
ROUTER_AUTOCONF_FILE = $(call qstrip,$(BR2_PACKAGE_ROUTER_AUTOCONF))

ROUTER_DEPENDENCIES = linux busybox

ifeq ($(ROUTER_VENDOR),netgear)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_BRIDGE_UTILS), bridge-utils)
else
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_DNSMASQ), dnsmasq)
endif

ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_E2FSPROGS), e2fsprogs)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_IPTABLES), iptables)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBCURL), libcurl)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBXML2), libxml2)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_OPENSSL), openssl)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_SQLITE), sqlite)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB), zlib)

define ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE
	$(SED) '/^include\s\+.*config/ { s|include \(..\/\)\{1,\}|include $(BR2_EXTERNAL_NETGEAR_PATH)/package/router/src\/|g }' $(if $(1),$(1),$(@D)/Makefile)
endef

define ROUTER_ALL_MAKEFILES_INCLUDE_SUPPRESS_SUBROUTINE
	find $(@D) -name 'Makefile' -exec $(SED) '/^include\s\+.*config\./ { s|include \(..\/\)\{1,\}|include $(BR2_EXTERNAL_NETGEAR_PATH)/package/router/src\/|g }' {} \;
endef

define ROUTER_BUILD_CMDS
	$(INSTALL) -m 0644 $(BR2_PACKAGE_ROUTER_CONFIG) $(@D)/.config;
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_NETGEAR_PATH)/package/router/src/config.in $(@D)/;
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_NETGEAR_PATH)/package/router/src/config.mk $(@D)/;
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) \
		HOST=_LINUX CC="$(TARGET_CC)" AR="$(TARGET_AR)" STRIP="$(TARGET_STRIP)" \
		$(ROUTER_MAKE_OPTS) all
endef

define ROUTER_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) \
		$(ROUTER_MAKE_OPTS) INSTALLFLAGS=-m755 install
	rsync -au $(@D)/arm-uclibc/target $(BASE_DIR)
endef

ifeq ($(BR2_PACKAGE_ROUTER),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_ROUTER_CONFIG)),)
$(error No router configuration file specified, check your BR2_PACKAGE_ROUTER_CONFIG setting)
endif
endif

$(eval $(kconfig-package))
