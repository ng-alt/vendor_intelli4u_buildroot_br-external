################################################################################
#
# accel-pptp
#
################################################################################

ACCEL_PPTP_SITE = http://accel-pptp.sourceforge.net
ACCEL_PPTP_VERSION_FILE = pptpd-1.3.3/configure.in
ACCEL_PPTP_LICENSE = GPLv2
ACCEL_PPTP_DEPENDENCIES = linux pppd

define ACCEL_PPTPD_BUILD_CMDS
	cd $(@D)/pptpd-1.3.3 && $(TARGET_CONFIGURE_OPTS) ./configure \
		--target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--prefix=/usr --bindir=/usr/sbin --libdir=/usr/lib --enable-bcrelay \
		KDIR=$(LINUX_DIR) PPPDIR=$(PPPD_DIR)
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) server
endef

define ACCEL_PPTPD_INSTALL_TARGET_CMDS
	install -D $(@D)/pptpd-1.3.3/pptpd $(TARGET_DIR)/usr/sbin/pptpd
	install -D $(@D)/pptpd-1.3.3/bcrelay $(TARGET_DIR)/usr/sbin/bcrelay
	install -D $(@D)/pptpd-1.3.3/pptpctrl $(TARGET_DIR)/usr/sbin/pptpctrl
endef

define ACCEL_PPTP_PLUGIN_BUILD_CMDS
	cd $(@D)/pppd_plugin && $(TARGET_CONFIGURE_OPTS) ./configure \
		--target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--prefix=/usr KDIR=$(LINUX_DIR) PPPDIR=$(PPPD_DIR)
	$(MAKE) -C $(@D)/pppd_plugin
endef

define ACCEL_PPTP_PLUGIN_INSTALL_TARGET_CMDS
	install -D $(@D)/pppd_plugin/src/.libs/pptp.so $(TARGET_DIR)/usr/lib/pppd/pptp.so
endef

define ACCEL_PPTP_BUILD_CMDS
	$(ACCEL_PPTPD_BUILD_CMDS)
	$(ACCEL_PPTP_PLUGIN_BUILD_CMDS)
endef

define ACCEL_PPTP_INSTALL_TARGET_CMDS
	$(ACCEL_PPTPD_INSTALL_TARGET_CMDS)
	$(ACCEL_PPTP_PLUGIN_INSTALL_TARGET_CMDS)
endef

$(eval $(generic-package))
