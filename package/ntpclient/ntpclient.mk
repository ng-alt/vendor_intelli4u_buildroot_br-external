################################################################################
#
# ntpclient
#
################################################################################

NTPCLIENT_SITE = http://doolittle.icarus.com/ntpclient
NTPCLIENT_LICENSE_FILES = COPYING
NTPCLIENT_DEPENDENCIES = router
NTPCLIENT_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE
NTPCLIENT_INSTALL_TARGET_OPTS = TARGETDIR=$(TARGET_DIR) install

NTPCLIENT_MAKE_OPTS += \
	CFLAGS="$(AVAHI_CFLAGS) -I$(SRC_BASE_DIR)/include -I$(ROUTER_DIR)/shared" \
	LDFLAGS="-L$(TARGET_DIR)/usr/lib -lnvram -lshared -lgcc_s"

define NTPCLIENT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/ntpclient $(TARGET_DIR)/sbin/ntpclient
endef

$(eval $(make-package))
