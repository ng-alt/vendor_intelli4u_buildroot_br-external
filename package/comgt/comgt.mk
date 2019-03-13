################################################################################
#
# comgt
#
################################################################################

COMGT_LICENSE = GPL-2.0+
COMGT_LICENSE_FILES = gpl.txt

COMGT_INSTALL_TARGET_OPTS = \
	INSTALLDIR="$(TARGET_DIR)" STRIP="$(TARGET_STRIP)" INSTALLFLAGS=-m755 install

$(eval $(make-package))
