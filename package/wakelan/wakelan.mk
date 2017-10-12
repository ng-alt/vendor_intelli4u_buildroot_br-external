################################################################################
#
# wakelan
#
################################################################################

WAKELAN_LICENSE = GPLv2
WAKELAN_LICENSE_FILES = COPYING
WAKELAN_MAKE_OPTS = CC="$(TARGET_CC)" AR="$(TARGET_AR)" STRIP="$(TARGET_STRIP)"
WAKELAN_INSTALL_TARGET_OPTS = TARGETDIR=$(TARGET_DIR) install
WAKELAN_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))
