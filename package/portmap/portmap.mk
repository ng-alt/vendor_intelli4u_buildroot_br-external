################################################################################
#
# portmap
#
################################################################################

PORTMAP_DEPENDENCIES = host-autoconf
PORTMAP_MAKE_OPTS = NO_TCP_WRAPPER=y

define PORTMAP_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/portmap $(TARGET_DIR)/usr/sbin/portmap
endef

$(eval $(make-package))
