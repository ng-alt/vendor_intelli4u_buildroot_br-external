################################################################################
#
# libexif
#
################################################################################

LIBEXIF_SITE = http://downloads.sourceforge.net/project/libexif/libexif
LIBEXIF_INSTALL_STAGING = YES
LIBEXIF_DEPENDENCIES = host-pkgconf
LIBEXIF_LICENSE = LGPL-2.1+
LIBEXIF_LICENSE_FILES = COPYING

$(eval $(autotools-package))
