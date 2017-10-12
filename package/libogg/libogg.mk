################################################################################
#
# libogg
#
################################################################################

LIBOGG_SITE = http://downloads.xiph.org/releases/ogg
LIBOGG_LICENSE = BSD-3-Clause
LIBOGG_LICENSE_FILES = COPYING
LIBOGG_AUTOGEN = YES
LIBOGG_INSTALL_STAGING = YES
LIBOGG_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
