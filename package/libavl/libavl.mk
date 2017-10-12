################################################################################
#
# libavl
#
################################################################################

LIBAVL_SITE = ftp://ftp.gnu.org/pub/gnu/avl
LIBAVL_INSTALL_STAGING = YES
LIBAVL_LICENSE = GNU
LIBAVL_LICENSE_FILES = COPYING
LIBAVL_INSTALL_TARGET_OPTS = DESTDIR="$(TARGET_DIR)" INSTALLFLAGS=-m755 install

$(eval $(make-package))
