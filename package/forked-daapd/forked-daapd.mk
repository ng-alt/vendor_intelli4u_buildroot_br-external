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
			rsync -au $(LIBUNISTRING_DIR)/$$m4 $(@D)/m4/; \
		fi \
	done; \
	for m4 in libgcrypt.m4 gpg-error.m4 ; do \
		if [ -e $(LIBGCRYPT_DIR)/$$m4 ] ; then \
			rsync -au $(LIBGCRYPT_DIR)/$$m4 $(@D)/m4/; \
		fi \
	done
endef

FORKED_DAAPD_PRE_CONFIGURE_HOOKS += FORKED_DAAPD_COPY_M4_FILES

define FORKED_DAAPD_INSTALL_START_SCRIPT
	$(INSTALL) -m 755 $(BR2_EXTERNAL_NETGEAR_PATH)/package/forked-daapd/start_forked-daapd.sh $(TARGET_DIR)/usr/sbin/
endef

FORKED_DAAPD_POST_INSTALL_TARGET_HOOKS += FORKED_DAAPD_INSTALL_START_SCRIPT

$(eval $(autotools-package))
