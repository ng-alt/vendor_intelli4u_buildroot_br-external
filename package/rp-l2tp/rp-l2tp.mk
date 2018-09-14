################################################################################
#
# rp-l2tp
#
################################################################################

RP_L2TP_LICENSE = LGPLv2
RP_L2TP_AUTORECONF = YES

#RP_L2TP_CONF_OPTS = ac_cv_prog_AR=$(TARGET_AR)

define RP_L2TP_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/l2tpd $(TARGET_DIR)/usr/sbin/l2tpd
endef

$(eval $(autotools-package))
