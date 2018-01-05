################################################################################
#
# lprng
#
################################################################################

LPRNG_LICENSE = GPLv2

LPRNG_CONF_ENV += CFLAGS="-I$(SRC_BASE_DIR)/include -I$(ROUTER_DIR)/shared" \
	LDFLAGS="-L$(TARGET_DIR)/usr/lib -lnvram"

$(eval $(autotools-package))
