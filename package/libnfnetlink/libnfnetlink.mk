################################################################################
#
# libnfnetlink
#
################################################################################

LIBNFNETLINK_SITE = http://www.netfilter.org/projects/libnfnetlink/files
LIBNFNETLINK_AUTORECONF = YES
LIBNFNETLINK_INSTALL_STAGING = YES
LIBNFNETLINK_LICENSE = GPL-2.0
LIBNFNETLINK_LICENSE_FILES = COPYING

$(eval $(autotools-package))
