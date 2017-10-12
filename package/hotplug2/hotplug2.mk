################################################################################
#
# hotplug2
#
################################################################################

HOTPLUG2_LICENSE = GPLv2
HOTPLUG2_LICENSE_FILES = COPYING

# install the prog directly not to use the confused one in Makefile
define HOTPLUG2_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/hotplug2 $(TARGET_DIR)/sbin/
endef

$(eval $(make-package))
