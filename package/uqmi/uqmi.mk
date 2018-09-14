################################################################################
#
# uqmi
#
################################################################################

UQMI_LICENSE = LGPLv2

define UQMI_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/uqmi $(TARGET_DIR)/usr/sbin/uqmi
endef

$(eval $(make-package))
