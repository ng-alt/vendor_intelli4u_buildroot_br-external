################################################################################
#
# hotplug2
#
################################################################################

HOTPLUG2_LICENSE = GPLv2
HOTPLUG2_LICENSE_FILES = COPYING

HOTPLUG2_DEPENDENCIES = $(if $(BR2_PACKAGE_ROUTER),router)

# install the prog directly not to use the confused one in Makefile
define HOTPLUG2_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/hotplug2 $(TARGET_DIR)/sbin/
	if [ -e $(TARGET_DIR)/rom ] ; then \
		$(INSTALL) $(@D)/examples/hotplug2.rules-2.6kernel $(TARGET_DIR)/rom/etc/hotplug2.rules; \
	fi
endef

$(eval $(make-package))
