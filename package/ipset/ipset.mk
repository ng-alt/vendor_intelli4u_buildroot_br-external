################################################################################
#
# ipset
#
################################################################################

IPSET_SITE = http://ipset.netfilter.org
IPSET_DEPENDENCIES = libmnl host-pkgconf
IPSET_CONF_OPTS = --with-kmod=no
IPSET_AUTOGEN = YES
IPSET_LICENSE = GPL-2.0
IPSET_LICENSE_FILES = COPYING

$(eval $(autotools-package))
