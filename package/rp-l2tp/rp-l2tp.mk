################################################################################
#
# rp-l2tp
#
################################################################################

RP_L2TP_LICENSE = LGPLv2
RP_L2TP_AUTORECONF = YES

define RP_L2TP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/l2tpd $(TARGET_DIR)/usr/sbin/l2tpd
	$(INSTALL) -m 0644 $(@D)/handlers/cmd.so $(TARGET_DIR)/usr/lib
endef

$(eval $(autotools-package))
