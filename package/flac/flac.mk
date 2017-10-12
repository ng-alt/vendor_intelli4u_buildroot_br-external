################################################################################
#
# flac
#
################################################################################

FLAC_SITE = http://downloads.xiph.org/releases/flac
FLAC_INSTALL_STAGING = YES
FLAC_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)
FLAC_LICENSE = Xiph BSD-like (libFLAC), GPL-2.0+ (tools), LGPL-2.1+ (other libraries)
FLAC_LICENSE_FILES = COPYING.Xiph COPYING.GPL COPYING.LGPL
# 0001-configure.ac-relax-linux-OS-detection.patch patches configure.ac
FLAC_AUTOGEN = YES
FLAC_CONF_OPTS = \
	--disable-cpplibs \
	--disable-xmms-plugin \
	--disable-altivec

ifeq ($(BR2_PACKAGE_LIBOGG),y)
FLAC_CONF_OPTS += --with-ogg=$(STAGING_DIR)/usr
FLAC_DEPENDENCIES += libogg
else
FLAC_CONF_OPTS += --disable-ogg
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
FLAC_DEPENDENCIES += host-nasm
FLAC_CONF_OPTS += --enable-sse
else
FLAC_CONF_OPTS += --disable-sse
endif

define FLAC_COPY_MISSED
	if [ ! -e $(@D)/config.rpath ] && [ -e /usr/share/gettext/config.rpath ] ; then cp /usr/share/gettext/config.rpath $(@D); fi
endef

define FLAC_DISABLE_UNNEEDED
	$(SED) 's/SUBDIRS = doc include m4 man src examples test build obj/SUBDIRS = include m4 src build obj/' \
		$(@D)/Makefile.am
endef
FLAC_PRE_CONFIGURE_HOOKS += FLAC_DISABLE_UNNEEDED FLAC_COPY_MISSED

$(eval $(autotools-package))
