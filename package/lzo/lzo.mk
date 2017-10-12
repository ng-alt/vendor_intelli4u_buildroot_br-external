################################################################################
#
# lzo
#
################################################################################

LZO_SITE = http://www.oberhumer.com/opensource/lzo/download
LZO_LICENSE = GPL-2.0+
LZO_LICENSE_FILES = COPYING
LZO_INSTALL_STAGING = YES
# Ships a beta libtool version hence our patch doesn't apply.
# Run autoreconf to regenerate ltmain.sh.
#LZO_AUTORECONF = YES
LZO_LIBTOOL_PATCH = NO

$(eval $(autotools-package))
$(eval $(host-autotools-package))
