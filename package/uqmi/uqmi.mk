################################################################################
#
# uqmi
#
################################################################################

UQMI_LICENSE = LGPLv2

UQMI_MAKE = $(MAKE1)

define UQMI_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/uqmi $(TARGET_DIR)/usr/sbin/uqmi
endef

$(eval $(make-package))
