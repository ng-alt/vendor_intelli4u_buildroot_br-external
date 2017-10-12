################################################################################
#
# vlan
#
################################################################################

VLAN_SITE = https://www.candelatech.com/~greear/vlan
VLAN_LICENSE = GPL-2.0+

VLAN_MAKE_OPTS = HOST=_LINUX CC="$(TARGET_CC)" AR="$(TARGET_AR)" STRIP="$(TARGET_STRIP)"

define VLAN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/vconfig $(TARGET_DIR)/usr/sbin/vconfig
endef

$(eval $(make-package))
