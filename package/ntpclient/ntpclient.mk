################################################################################
#
# ntpclient
#
################################################################################

NTPCLIENT_SITE = http://doolittle.icarus.com/ntpclient
NTPCLIENT_LICENSE_FILES = COPYING
NTPCLIENT_DEPENDENCIES = router
NTPCLIENT_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

define NTPCLIENT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/ntpclient $(TARGET_DIR)/sbin/ntpclient
endef

$(eval $(make-package))
