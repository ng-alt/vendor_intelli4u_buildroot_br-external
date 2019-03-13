################################################################################
#
# libubox
#
################################################################################

LIBUBOX_LICENSE =  BSD 3-Clause
LIBUBOX_INSTALL_STAGING = YES

define LIBUBOX_INSTALL_STAGING_CMDS
	$(INSTALL) $(@D)/libubox.a $(STAGING_DIR)/usr/lib/libubox.a
endef

define LIBUBOX_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/libubox.a $(TARGET_DIR)/usr/lib/libubox.a
endef

$(eval $(make-package))
