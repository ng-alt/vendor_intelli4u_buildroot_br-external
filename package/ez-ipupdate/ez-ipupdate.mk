################################################################################
#
# ez-ipupdate
#
################################################################################

EZ_IPUPDATE_LICENSE = GPLv2
EZ_IPUPDATE_DEPENDENCIES = $(if $(BR2_PACKAGE_ROUTER),router)

EZ_IPUPDATE_MAKE_OPTS = \
    CFLAGS="-DASUS_DDNS -I$(if $(SRC_BASE_DIR),$(SRC_BASE_DIR),$(BR2_TOPDIR)$(SRCBASE))/include -I$(ROUTER_DIR)/shared" \
	LDFLAGS="-L$(TARGET_DIR)/usr/lib -lnvram -lshared -lgcc_s"

define EZ_IPUPDATE_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/ez-ipupdate $(TARGET_DIR)/usr/sbin/ez-ipupdate
endef

EZ_IPUPDATE_PRE_BUILD_HOOKS += ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))
