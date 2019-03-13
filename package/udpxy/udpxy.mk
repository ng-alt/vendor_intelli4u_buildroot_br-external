################################################################################
#
# udpxy
#
################################################################################

UDPXY_VERSION = 1.0.23-9-prod
UDPXY_SOURCE = udpxy.$(UDPXY_VERSION).tar.gz
UDPXY_SITE = http://www.udpxy.com/download/1_23
UDPXY_SUBDIR = chipmunk
UDPXY_LICENSE = GPL-3.0+
UDPXY_LICENSE_FILES = README

define UDPXY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) NO_UDPXREC=yes -C $(@D)/$(UDPXY_SUBDIR)
endef

define UDPXY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) NO_UDPXREC=yes DESTDIR=$(TARGET_DIR) PREFIX=/usr \
		-C $(@D)/$(UDPXY_SUBDIR) install
endef

$(eval $(generic-package))
