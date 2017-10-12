################################################################################
#
# mxml
#
################################################################################

MXML_SITE = https://github.com/michaelrsweet/mxml/releases/download
MXML_LICENSE = LGPL-2.0+ with exceptions
MXML_LICENSE_FILES = COPYING
MXML_INSTALL_STAGING = YES
MXML_MAKE_OPTS = libmxml.a libmxml.so.1.5

define MXML_INSTALL_STAGING_CMDS
	$(INSTALL) -D $(@D)/libmxml.a $(STAGING_DIR)/usr/lib/libmxml.a
	$(INSTALL) -D $(@D)/libmxml.so.1.5 $(STAGING_DIR)/usr/lib/libmxml.so.1.5
	$(INSTALL) -D $(@D)/mxml.h $(STAGING_DIR)/usr/include/
	$(INSTALL) -D $(@D)/mxml.pc $(STAGING_DIR)/usr/lib/pkgconfig/mxml.pc
endef

define MXML_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mxml.h $(TARGET_DIR)/usr/include/
	$(INSTALL) -D $(@D)/libmxml.so.1.5 $(TARGET_DIR)/usr/lib/libmxml.so.1.5
	$(INSTALL) -D $(@D)/mxml.pc $(TARGET_DIR)/usr/lib/pkgconfig/mxml.pc
endef

$(eval $(autotools-package))
