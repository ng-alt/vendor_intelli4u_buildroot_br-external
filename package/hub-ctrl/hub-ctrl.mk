################################################################################
#
# hub-ctrl
#
################################################################################

HUB_CTRL_LICENSE = GPL-2.0+

HUB_CTRL_MAKE_OPTS = CFLAGS="-I$(LIBUSB_DIR)/libusb" LDFLAGS="-L$(TARGET_DIR)/usr/lib"

define HUB_CTRL_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/hub-ctrl $(TARGET_DIR)/usr/sbin/hub-ctrl
endef

$(eval $(make-package))
