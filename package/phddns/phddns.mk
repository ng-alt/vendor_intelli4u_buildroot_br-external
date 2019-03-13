################################################################################
#
# phddns
#
################################################################################

PHDDNS_LICENSE = GPLv2
PHDDNS_DEPENDENCIES = $(if $(BR2_PACKAGE_ROUTER),router)

PHDDNS_CONF_OPTS = \
	CFLAGS="-Os -I$(SRC_BASE_DIR)/include -I$(ROUTER)/shared $(EXTRACFLAGS)" \
		LIBS="-L$(TARGET_DIR)/usr/lib -lnvram -lshared -lgcc_s"

define PHDDNS_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/phddns $(TARGET_DIR)/usr/sbin/phddns
endef

$(eval $(autotools-package))
