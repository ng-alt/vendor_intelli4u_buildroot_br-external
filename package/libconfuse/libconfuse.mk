################################################################################
#
# libconfuse
#
################################################################################

LIBCONFUSE_SITE = https://github.com/martinh/libconfuse/releases/download
LIBCONFUSE_LICENSE = ISC
LIBCONFUSE_LICENSE_FILES = LICENSE
LIBCONFUSE_AUTOGEN = YES
LIBCONFUSE_INSTALL_STAGING = YES
LIBCONFUSE_CONF_OPTS = --disable-rpath
LIBCONFUSE_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

$(eval $(autotools-package))
