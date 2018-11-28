################################################################################
#
# lprng
#
################################################################################

LPRNG_LICENSE = GPLv2
LPRNG_MAKE = $(MAKE1)

LPRNG_CONF_OPTS = --disable-werror
LPRNG_CONF_ENV += \
	CFLAGS="-I$(SRC_BASE_DIR)/include -I$(ROUTER_DIR)/shared -DLPR_with_ASUS" \
	LDFLAGS="-L$(TARGET_DIR)/usr/lib -lnvram -lshared -lgcc_s"

$(eval $(autotools-package))
