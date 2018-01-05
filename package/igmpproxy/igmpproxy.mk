################################################################################
#
# igmpproxy
#
################################################################################

IGMPPROXY_SITE = http://github/pali/igmpproxy
IGMPPROXY_AUTOGEN = YES
IGMPPROXY_AUTOGEN_SCRIPT = bootstrap
IGMPPROXY_LICENSE = GPL-2.0+
IGMPPROXY_LICENSE_FILES = COPYING

define IGMPPROXY_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/src/igmpproxy $(TARGET_DIR)/usr/sbin/igmpproxy
endef

$(eval $(autotools-package))
