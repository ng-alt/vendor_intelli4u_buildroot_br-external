################################################################################
#
# miniupnp
#
################################################################################

MINIUPNP_SITE = https://github.com/westes/flex/files/981163
MINIUPNP_VERSION_FILE = miniupnpd/VERSION
MINIUPNP_LICENSE = BSD-3-Clause
MINIUPNP_LICENSE_FILE =
MINIUPNP_DEPENDENCIES = e2fsprogs iptables

ifeq ($(BR2_TARGET_ENABLE_MINIUPNPD),y)
define MINIUPNPD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D)/miniupnpd -f Makefile.merlin IPTABLESPATH=$(IPTABLES_DIR)
endef

define MINIUPNPD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D)/miniupnpd -f Makefile.merlin install DESTDIR=$(TARGET_DIR)
endef
endif

ifeq ($(BR2_TARGET_ENABLE_MINIUPNPC),y)
define MINIUPNPC_BUILD_CMDS
	$(call ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE,$(@D)/miniupnpc/Makefile)
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/miniupnpc \
		TOP=$(ROUTER_DIR) SRCBASE=$(SRC_BASE_DIR) \
		LINUX_DIR="$(LINUX_DIR)" LINUX_OUTDIR="$(LINUX_DIR)" \
		LINUXDIR=$(if $(LINUX_OVERRIDE2_SRCDIR),$(LINUX_OVERRIDE2_SRCDIR),$(LINUX_DIR))
endef

define MINIUPNPC_INSTALL_TARGET_CMDS
	install -D $(@D)/miniupnpc/upnpc-static $(TARGET_DIR)/miniupnpc/usr/sbin/miniupnpc
endef
endif

define MINIUPNP_BUILD_CMDS
	$(MINIUPNPD_BUILD_CMDS)
	$(MINIUPNPC_BUILD_CMDS)
endef

define MINIUPNP_INSTALL_TARGET_CMDS
	$(MINIUPNPD_INSTALL_TARGET_CMDS)
	$(MINIUPNPC_INSTALL_TARGET_CMDS)
endef

$(eval $(generic-package))
