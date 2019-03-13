################################################################################
#
# ipset
#
################################################################################

IPSET_VERSION_FILE = Makefile
IPSET_VERSION_PATTERN = "^IPSET_VERSION:=(.+)"
IPSET_SITE = http://ipset.netfilter.org
IPSET_DEPENDENCIES = libmnl host-pkgconf
IPSET_CONF_OPTS = --with-kmod=no
IPSET_LICENSE = GPL-2.0
IPSET_LICENSE_FILES = COPYING
IPSET_MAKE_OPTS = binaries

define IPSET_INSTALL_TARGET_CMDS
	install -D $(@D)/ipset $(TARGET_DIR)/usr/sbin/ipset
#	install -d $(TARGET_DIR)/usr/lib/ipset
#	install $(@D)/*.so $(TARGET_DIR)/usr/lib/ipset
endef

$(eval $(make-package))
