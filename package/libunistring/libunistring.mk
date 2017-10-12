################################################################################
#
# libunistring
#
################################################################################

LIBUNISTRING_SITE = $(BR2_GNU_MIRROR)/libunistring
LIBUNISTRING_AUTOGEN = YES
LIBUNISTRING_AUTOGEN_ENV = GNULIB_TOOL=$(LIBUNISTRING_DIR)/gnulib/gnulib-tool 
LIBUNISTRING_INSTALL_STAGING = YES
LIBUNISTRING_LICENSE = LGPL-3.0+ or GPL-2.0
LIBUNISTRING_LICENSE_FILES = COPYING.LIB

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBUNISTRING_CONF_OPTS += --enable-threads=posix
else
LIBUNISTRING_CONF_OPTS += --disable-threads
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
