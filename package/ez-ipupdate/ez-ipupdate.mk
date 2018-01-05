################################################################################
#
# ez-ipupdate
#
################################################################################

EZ_IPUPDATE_LICENSE = GPLv2
EZ_IPUPDATE_DEPENDENCIES = router
EZ_IPUPDATE_AUTORECONF = YES

EZ_IPUPDATE_MAKE_OPTS = \
    CFLAGS="-DASUS_DDNS -I$(ROOT)$(SRCBASE)/include -I$(ROUTER_DIR)/shared" \
	LDFLAGS="-L$(TARGET_DIR)/usr/lib -lnvram -lshared -lgcc_s"

define EZ_IPUPDATE_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/ez-ipupdate $(TARGET_DIR)/usr/sbin/ez-ipupdate
endef

$(eval $(autotools-package))
