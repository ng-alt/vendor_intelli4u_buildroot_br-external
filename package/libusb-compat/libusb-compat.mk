################################################################################
#
# libusb-compat
#
################################################################################

LIBUSB_COMPAT_DEPENDENCIES = host-pkgconf libusb
LIBUSB_COMPAT_AUTOGEN = YES
LIBUSB_COMPAT_INSTALL_STAGING = YES
LIBUSB_COMPAT_CONFIG_SCRIPTS = libusb-config
LIBUSB_COMPAT_LICENSE = LGPL-2.1+
LIBUSB_COMPAT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
