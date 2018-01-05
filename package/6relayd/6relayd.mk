################################################################################
#
# 6relayd
#
################################################################################

6RELAYD_LICENSE = GPL-2.0+
6RELAYD_LICENSE_FILES = COPYING

6RELAYD_INSTALL_TARGET_OPTS = \
	DESTDIR="$(TARGET_DIR)" PREFIX=/usr STRIP="$(TARGET_STRIP)" \
	INSTALLFLAGS=-m755 install

$(eval $(make-package))
