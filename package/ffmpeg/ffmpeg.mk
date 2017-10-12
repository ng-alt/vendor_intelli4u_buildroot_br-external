################################################################################
#
# ffmpeg
#
################################################################################

FFMPEG_SITE = http://ffmpeg.org/releases
FFMPEG_INSTALL_STAGING = YES

FFMPEG_LICENSE = LGPL-2.1+, libjpeg license
FFMPEG_LICENSE_FILES = LICENSE.md COPYING.LGPLv2.1
ifeq ($(BR2_PACKAGE_FFMPEG_GPL),y)
FFMPEG_LICENSE += and GPL-2.0+
FFMPEG_LICENSE_FILES += COPYING.GPLv2
endif

FFMPEG_CONF_OPTS = \
	--prefix=/usr \
	--enable-shared \
	--enable-gpl \
	--enable-cross-compile \
	--disable-muxers \
	--disable-encoders \
	--disable-filters \
	--disable-vhook \
	--extra-cflags=-fPIC


FFMPEG_CONF_OPTS += $(call qstrip,$(BR2_PACKAGE_FFMPEG_EXTRACONF))

# Override FFMPEG_CONFIGURE_CMDS: FFmpeg does not support --target and others
define FFMPEG_CONFIGURE_CMDS
	(cd $(FFMPEG_SRCDIR) && rm -rf config.cache && \
	if [ -e VERSION ] ; then cp VERSION snapshot_version ; fi; \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(FFMPEG_CONF_ENV) \
	./configure \
		--enable-cross-compile \
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc="$(HOSTCC)" \
		--arch=$(BR2_ARCH) \
		--target-os="linux" \
		$(if $(BR2_GCC_TARGET_TUNE),--cpu=$(BR2_GCC_TARGET_TUNE)) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(FFMPEG_CONF_OPTS) \
	)
endef

$(eval $(autotools-package))
