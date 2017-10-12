################################################################################
#
# libantlr
#
################################################################################

LIBANTLR_SITE = https://github.com/antlr/website-antlr3/tree/gh-pages/download/C
LIBANTLR_INSTALL_STAGING = YES
LIBANTLR_LICENSE = FLEX
LIBANTLR_LICENSE_FILES = COPYING

$(eval $(autotools-package))
