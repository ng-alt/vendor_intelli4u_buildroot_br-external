################################################################################
#
# usb_modeswitch
#
################################################################################

USB_MODESWITCH_VERSION_FILE = $(BUILDROOT)external/usb_modeswitch/Makefile
USB_MODESWITCH_VERSION_PATTERN = "VERS\s*=\s*([^ ]+)"
USB_MODESWITCH_DEPENDENCIES = libusb
USB_MODESWITCH_LICENSE = GPL-2.0+
USB_MODESWITCH_LICENSE_FILES = COPYING

USB_MODESWITCH_BUILD_TARGETS = static
USB_MODESWITCH_INSTALL_TARGETS = install-static

ifeq ($(BR2_PACKAGE_TCL)$(BR2_PACKAGE_TCL_SHLIB_ONLY),y)
USB_MODESWITCH_DEPENDENCIES += tcl
USB_MODESWITCH_BUILD_TARGETS = script
USB_MODESWITCH_INSTALL_TARGETS = install-script
endif

# build system of embedded jimtcl doesn't use autotools, but does use
# an old version of gnuconfig which doesn't know all the architectures
# supported by Buildroot, so update config.guess / config.sub like we
# do in pkg-autotools.mk
USB_MODESWITCH_POST_PATCH_HOOKS += UPDATE_CONFIG_HOOK

define USB_MODESWITCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE -Wall -I." \
		LDFLAGS="-ldl" \
		JIM_CONFIGURE_OPTS="--host=$(GNU_TARGET_NAME) --build=$(GNU_HOST_NAME)" \
		-C $(@D) $(USB_MODESWITCH_BUILD_TARGETS)
endef

define USB_MODESWITCH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE -Wall -I." \
		LDFLAGS="-ldl" \
		DESTDIR=$(TARGET_DIR) \
		-C $(@D) $(USB_MODESWITCH_INSTALL_TARGETS)
	if [ -d $(TARGET_DIR)/rom/etc ] ; then \
		$(INSTALL) -D -m 0644 $(@D)/usb_modeswitch.conf $(TARGET_DIR)/rom/etc/usb_modeswitch.conf; \
		$(SED) 's/#.*//g;s/[ \t]\+/ /g;s/^[ \t]*//;s/[ \t]*$$//;/^$$/d' $(TARGET_DIR)/rom/etc/usb_modeswitch.conf; \
	fi
endef

$(eval $(generic-package))
