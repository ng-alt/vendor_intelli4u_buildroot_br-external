################################################################################
#
# netstat-nat
#
################################################################################

NETSTAT_NAT_SITE = http://tweegy.nl/download
NETSTAT_NAT_LICENSE = GPL-2.0+
NETSTAT_NAT_LICENSE_FILES = COPYING

define NETSTAT_NAT_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/netstat-nat $(TARGET_DIR)/usr/sbin/netstat-nat
endef

$(eval $(autotools-package))
