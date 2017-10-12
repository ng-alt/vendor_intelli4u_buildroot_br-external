################################################################################
#
# udev
#
################################################################################

UDEV_SITE = https://www.kernel.org/pub/linux/utils/kernel/hotplug
UDEV_LICENSE = GPLv2
UDEV_LICENSE_FILE = COPYGING

UDEV_MAKE_ENV = CROSS_COMPILE="$(TARGET_CROSS)"
UDEV_MAKE_OPTS = all

UDEV_INSTALL_TARGET_OPTS = prefix=$(TARGET_DIR) install-udevtrigger

define UDEV_FIX_LIBVOLUME_ID_SOFTLINK
	$(SED) 's,ln -sf $$(libdir)/$$(SHLIB) $$(DESTDIR)$$(usrlibdir)/libvolume_id.so,ln -sf /lib/$$(SHLIB) $$(DESTDIR)$$(usrlibdir)/libvolume_id.so,' \
		$(@D)/extras/volume_id/lib/Makefile
endef
UDEV_PRE_BUILD_HOOKS += UDEV_FIX_LIBVOLUME_ID_SOFTLINK

$(eval $(make-package))
