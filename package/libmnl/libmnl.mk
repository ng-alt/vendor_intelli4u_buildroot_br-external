################################################################################
#
# libmnl
#
################################################################################

LIBMNL_SITE = http://netfilter.org/projects/libmnl/files
LIBMNL_INSTALL_STAGING = YES
LIBMNL_LICENSE = LGPL-2.1+
LIBMNL_LICENSE_FILES = COPYING
LIBMNL_AUTOGEN = YES

$(eval $(autotools-package))
