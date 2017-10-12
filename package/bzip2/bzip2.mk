################################################################################
#
# bzip2
#
################################################################################

BZIP2_SITE = http://www.bzip.org
BZIP2_INSTALL_STAGING = YES
BZIP2_LICENSE = bzip2 license
BZIP2_LICENSE_FILES = LICENSE

BZIP2_PRE_BUILD_HOOKS = ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

define BZIP2_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS)
		$(MAKE) -C $(@D) libbz2.a bzip2 bzip2recover $(TARGET_CONFIGURE_OPTS)
endef

# make sure busybox doesn't get overwritten by make install
define BZIP2_INSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,bzip2 bunzip2 bzcat)
	$(TARGET_CONFIGURE_OPTS) $(MAKE) \
		PREFIX=$(TARGET_DIR)/usr/sbin -C $(@D) install
endef

define HOST_BZIP2_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) -f Makefile-libbz2_so
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) libbz2.a bzip2 bzip2recover
endef

define HOST_BZIP2_INSTALL_CMDS
	$(HOST_MAKE_ENV) \
		$(MAKE) PREFIX=$(HOST_DIR) -C $(@D) install
	$(HOST_MAKE_ENV) \
		$(MAKE) -f Makefile PREFIX=$(HOST_DIR) -C $(@D) install
endef

$(eval $(generic-package))
