################################################################################
#
# zeroconf
#
################################################################################

ZEROCONF_SITE = http://www.zeroconf.org
ZEROCONF_VERSION_FILE = NEWS
ZEROCONF_LICENSE = GPL-2.0
ZEROCONF_LICENSE_FILES = COPYING
ZEROCONF_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

define ZEROCONF_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define ZEROCONF_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) install \
		TARGETDIR=$(TARGET_DIR)
endef

$(eval $(generic-package))
