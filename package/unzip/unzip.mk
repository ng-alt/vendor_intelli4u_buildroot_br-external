################################################################################
#
# unzip
#
################################################################################

UNZIP_VERSION_FILE = unzvers.h
UNZIP_VERSION_PATTERN = "^\#define\s+UZ_VER_STRING\s+\"([^\"]+)\""
UNZIP_SITE = ftp://ftp.info-zip.org/pub/infozip/src
UNZIP_LICENSE = Info-ZIP
UNZIP_LICENSE_FILES = LICENSE
# take precedence over busybox implementation
UNZIP_DEPENDENCIES = $(if $(BR2_PACKAGE_BUSYBOX),busybox)
UNZIP_INSTALL_TARGET_OPTS = prefix=$(TARGET_DIR)/usr/sbin install

UNZIP_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))
