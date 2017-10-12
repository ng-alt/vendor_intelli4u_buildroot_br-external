################################################################################
#
# hdparm
#
################################################################################

HDPARM_SITE = http://downloads.sourceforge.net/project/hdparm/hdparm
HDPARM_LICENSE = BSD-Style
HDPARM_LICENSE_FILES = LICENSE.TXT

define HDPARM_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/hdparm $(TARGET_DIR)/sbin/hdparm
endef

$(eval $(make-package))
