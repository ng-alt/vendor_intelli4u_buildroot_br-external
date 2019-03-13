################################################################################
#
# bridge-utils
#
################################################################################

BRIDGE_UTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/net/bridge-utils
BRIDGE_UTILS_AUTORECONF = YES
BRIDGE_UTILS_CONF_OPTS = --with-linux-headers=$(LINUX_DIR)/include
BRIDGE_UTILS_LICENSE = GPL-2.0+
BRIDGE_UTILS_LICENSE_FILES = COPYING

define BRIDGE_UTILS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		HOST=_LINUX CC="$(TARGET_CC)" \
		DESTDIR=$(TARGET_DIR) all
endef

define BRIDGE_UTILS_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		HOST=_LINUX CC="$(TARGET_CC)" INSTALL=install \
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(autotools-package))
