################################################################################
#
# pptpd
#
################################################################################

PPTPD_LICENSE = GPL-2.0
PPTPD_LICENSE_FILES = COPYING
PPTPD_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) TARGETDIR=$(TARGET_DIR) install-sbinPROGRAMS

$(eval $(autotools-package))

