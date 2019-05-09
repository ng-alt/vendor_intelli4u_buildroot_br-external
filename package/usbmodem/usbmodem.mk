################################################################################
#
# usbmodem
#
################################################################################

define USBMODEM_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILE=$(TARGET_CC) -C $(@D)/driver
endef

define USBMODEM_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILE=$(TARGET_CC) -C $(@D)/driver install TARGETDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
