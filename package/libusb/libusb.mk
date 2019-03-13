################################################################################
#
# libusb
#
################################################################################

LIBUSB_LICENSE = LGPL-2.1+
LIBUSB_LICENSE_FILES = COPYING
LIBUSB_DEPENDENCIES = host-pkgconf
LIBUSB_AUTOGEN = YES
LIBUSB_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBUSB_DEPENDENCIES += udev
else
LIBUSB_CONF_OPTS += --disable-udev
endif

$(eval $(autotools-package))
