################################################################################
#
# xz
#
################################################################################

XZ_SITE = http://tukaani.org/xz
XZ_INSTALL_STAGING = YES
XZ_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
XZ_LICENSE = GPL-2.0+, GPL-3.0+, LGPL-2.1+
XZ_LICENSE_FILES = COPYING.GPLv2 COPYING.GPLv3 COPYING.LGPLv2.1
XZ_AUTOGEN = YES

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
XZ_CONF_OPTS += --enable-threads
else
XZ_CONF_OPTS += --disable-threads
endif

ifneq ($(BR2_PACKAGE_XZ_XZ),y)
XZ_CONF_OPTS += --disable-xz
endif

ifneq ($(BR2_PACKAGE_XZ_XZDEC),y)
XZ_CONF_OPTS += --disable-xzdec
endif

ifneq ($(BR2_PACKAGE_XZ_LZXZDEC),y)
XZ_CONF_OPTS += --disable-lzmadec
endif

ifneq ($(BR2_PACKAGE_XZ_LZMAINFO),y)
XZ_CONF_OPTS += --disable-lzmainfo
endif

ifneq ($(BR2_PACKAGE_XZ_LZMALINK),y)
XZ_CONF_OPTS += --disable-lzma-links
endif

ifneq ($(BR2_PACKAGE_XZ_LZMA_SCRIPTS),y)
XZ_CONF_OPTS += --disable-scripts
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
