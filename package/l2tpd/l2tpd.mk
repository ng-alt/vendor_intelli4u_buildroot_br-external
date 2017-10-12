################################################################################
#
# l2tpd
#
################################################################################

L2TPD_LICENSE = GPLv2
L2TPD_LICENSE_FILES = COPYING
L2TPD_VERSION_FILE = l2tp.h
L2TPD_DEPENDENCIES = router

L2TPD_MAKE_ENV = LINUXDIR=$(LINUX_DIR)
L2TPD_INSTALL_TARGET_OPTS = TARGETDIR=$(TARGET_DIR) install
L2TPD_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))


