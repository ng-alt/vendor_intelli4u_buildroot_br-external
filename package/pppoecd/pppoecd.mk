################################################################################
#
# pppoecd
#
################################################################################

PPPOECD_LICENSE = GPL-2.0
PPPOECD_LICENSE_FILES = COPYING

PPPOECD_INSTALL_TARGET_OPTS = INSTALLDIR=$(TARGET_DIR) install
PPPOECD_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))

