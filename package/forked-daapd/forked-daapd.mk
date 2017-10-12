################################################################################
#
# forked-daapd
#
################################################################################

FORKED_DAAPD_MAKE = $(MAKE1)
FORKED_DAAPD_LICENSE = GPLv2
FORKED_DAAPD_LICENSE_FILES = COPYING
FORKED_DAAPD_AUTORECONF = YES
FORKED_DAAPD_AUTOMAKE = YES
FORKED_DAAPD_DEPENDENCIES = alsa-lib avahi dbus expat ffmpeg gdbm gperf \
	libantlr libavl libconfuse libdaemon libevent libgcrypt \
	libgpg-error libiconv libunistring mxml sqlite tre zlib

FORKED_DAAPD_CONF_ENV = \
    acl_cv_hardcode_minus_L=no
	
FORKED_DAAPD_CONF_OPTS = \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr
	
FORKED_DAAPD_MAKE_OPTS = CFLAGS="$(TARGET_CFLAGS) \
-DLIBAVFORMAT_VERSION_MAJOR=$(shell pkg-config --modversion libavformat | cut -d. -f1) \
-DLIBAVCODEC_VERSION_MINOR=$(shell pkg-config --modversion libavformat | cut -d. -f2)"

define FORKED_DAAPD_COPY_M4_FILES
	for m4 in iconv.m4 lib-ld.m4 lib-link.m4 lib-prefix.m4 ; do \
		if [ -e $(LIBUNISTRING_DIR)/$$m4 ] ; then \
			rsync -au $(LIBUNISTRING_DIR)/$$m4 $(FORKED_DAAPD_DIR)/m4/; \
		fi \
	done; \
	for m4 in libgcrypt.m4 gpg-error.m4 ; do \
		if [ -e $(LIBGCRYPT_DIR)/$$m4 ] ; then \
			rsync -au $(LIBGCRYPT_DIR)/$$m4 $(FORKED_DAAPD_DIR)/m4/; \
		fi \
	done
endef

define FORKED_DAAPD_PATCH_CODES
	# patch the change of netgear
	rsync -au  $(BR2_EXTERNAL_NETGEAR_PATH)/package/forked-daapd/src $(FORKED_DAAPD_DIR)/
	# patch Makefile.am for cache.c
	$(SED) 's,scan-wma.c \\,scan-wma.c cache.c \\,' $(FORKED_DAAPD_DIR)/src/Makefile.am
	# patch for the location of event-config.h
	$(SED) 's,<event-config.h>,<event2/event-config.h>,' $(FORKED_DAAPD_DIR)/src/evhttp/http.c
	$(SED) 's,<event-config.h>,<event2/event-config.h>,' $(FORKED_DAAPD_DIR)/src/evrtsp/rtsp.c
endef

FORKED_DAAPD_PRE_CONFIGURE_HOOKS += FORKED_DAAPD_COPY_M4_FILES FORKED_DAAPD_PATCH_CODES

define FORKED_DAAPD_INSTALL_START_SCRIPT
	$(INSTALL) -m 755 $(BR2_EXTERNAL_NETGEAR_PATH)/package/forked-daapd/start_forked-daapd.sh $(TARGET_DIR)/usr/sbin/
endef

FORKED_DAAPD_POST_INSTALL_TARGET_HOOKS += FORKED_DAAPD_INSTALL_START_SCRIPT

$(eval $(autotools-package))
