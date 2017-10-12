################################################################################
#
# udhcpd
#
################################################################################

UDHCPD_SITE = https://udhcp.busybox.net/source
UDHCPD_VERSION_FILE = libbb_udhcp.h
UDHCPD_LICENSE = GPLv2
UDHCPD_LICENSE_FILES = COPYGING

UDHCPD_MAKE_ENV = CROSS_COMPILE="$(TARGET_CROSS)"
UDHCPD_INSTALL_TARGET_OPTS = prefix=$(TARGET_DIR)/usr install
UDHCPD_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))
