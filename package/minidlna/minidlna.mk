################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_SITE = http://downloads.sourceforge.net/project/minidlna/minidlna
MINIDLNA_VERSION_FILE = upnpglobalvars.h
MINIDLNA_LICENSE = GPL-2.0, BSD-3-Clause
MINIDLNA_LICENSE_FILES = COPYING LICENCE.miniupnpd
MINIDLNA_AUTOGEN = YES
MINIDLNA_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	flac libvorbis libogg libid3tag libexif libjpeg sqlite

ifeq ($(BR2_PACKAGE_FFMPEG),y)
MINIDLNA_DEPENDENCIES += ffmpeg
MINIDLNA_AVLIB_DIR = $(FFMPEG_DIR)
else ifeq ($(BR2_PACKAGE_LIBAV),y)
MINIDLNA_DEPENDENCIES += libav
MINIDLNA_AVLIB_DIR = $(LIBAV_DIR)
endif

MINIDLNA_CONF_OPTS = \
	--disable-static

define MINIDLNA_INSTALL_CONF
	$(INSTALL) -D -m 644 $(@D)/minidlna.conf $(TARGET_DIR)/etc/minidlna.conf
endef

MINIDLNA_POST_INSTALL_TARGET_HOOKS += MINIDLNA_INSTALL_CONF

define MINIDLNA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CFLAGS="$(ZIP_TARGET_CFLAGS) $(ZIP_CFLAGS) -I$(MINIDLNA_AVLIB_DIR) -I$(MINIDLNA_AVLIB_DIR)/libavcodec \
		-I$(MINIDLNA_AVLIB_DIR)/libavformat -I$(MINIDLNA_AVLIB_DIR)/libavutil -I$(SQLITE_DIR) -I$(LIBEXIF_DIR) \
		-I$(LIBID3TAG_DIR) -I$(LIBOGG_DIR) -I$(LIBVORBIS_DIR) -I$(LIBJPEG_DIR) -Iinclude" \
		AS="$(TARGET_CC) -c" MINIDLNA_AVLIB_DIR=$(MINIDLNA_AVLIB_DIR) SQLITE_DIR=$(SQLITE_DIR) \
		LIBEXIF_DIR=$(LIBEXIF_DIR) LIBID3TAG_DIR=$(LIBID3TAG_DIR) \
		LIBOGG_DIR=$(LIBOGG_DIR) LIBVORBIS_DIR=$(LIBVORBIS_DIR) \
		LIBJPEG_DIR=$(LIBJPEG_DIR)
endef

define MINIDLNA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/minidlnad $(TARGET_DIR)/usr/sbin/minidlna
endef


$(eval $(autotools-package))

