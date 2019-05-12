################################################################################
#
# ipset
#
################################################################################

IPSET_SITE = http://ipset.netfilter.org
IPSET_DEPENDENCIES = libmnl linux host-pkgconf
IPSET_CONF_OPTS = \
	--with-kmod=yes \
	--enable-settype-modules \
	--with-kbuild=$(LINUX_DIR) \
	--with-ksource=$(LINUX_SRCDIR)
IPSET_AUTOGEN = YES
IPSET_LICENSE = GPL-2.0
IPSET_LICENSE_FILES = COPYING

define IPSET_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) modules
endef

define IPSET_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) install DESTDIR=$(TARGET_DIR) TARGETDIR=$(TARGET_DIR)
#	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) modules_install DESTDIR=$(TARGET_DIR) TARGETDIR=$(TARGET_DIR)
	KERNEL_RELEASE=`cat $(LINUX_DIR)/include/config/kernel.release`; \
	$(INSTALL) -d $(TARGET_DIR)/lib/modules/$$KERNEL_RELEASE/kernel/drivers/net/ipset/; \
	for ko in $(@D)/kernel/net/netfilter/*.ko $(@D)/kernel/net/netfilter/ipset/*.ko ; do \
		$(INSTALL) -c -m 0644 $$ko $(TARGET_DIR)/lib/modules/$$KERNEL_RELEASE/kernel/drivers/net/ipset/; \
	done
endef

$(eval $(autotools-package))
