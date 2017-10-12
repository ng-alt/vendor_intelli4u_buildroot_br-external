################################################################################
#
# igmpv3proxy
#
################################################################################

IGMPV3PROXY_SITE = http://madynes.loria.fr/igmpv3proxy
IGMPV3PROXY_LICENSE = GPL-2.0+
IGMPV3PROXY_LICENSE_FILES = COPYING
IGMPV3PROXY_DEPENDENCIES = router

IGMPV3PROXY_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) INSTALLDIR=$(TARGET_DIR) TARGETDIR=$(TARGET_DIR) install

define IGMPV3PROXY_UPDATE_CFLAGS
	$(SED) 's,-I$$(SRCDIR)/include -I../../acos/include,-I$$(SRCDIR)/include -I$(BR2_TOPDIR)$(ACOS)/include -I../../acos/include,g' \
		-e 's,-L$$(ROUTERDIR)/nvram -L$$(INSTALLDIR)/nvram/usr/lib,-lgcc_s -lc -L$(TARGET_DIR)/usr/lib,g' \
		-e 's,-L../../acos/shared -L$$(TARGETDIR)/shared/usr/lib,,g' $(@D)/Makefile
endef
IGMPV3PROXY_PRE_BUILD_HOOKS = IGMPV3PROXY_UPDATE_CFLAGS ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))
