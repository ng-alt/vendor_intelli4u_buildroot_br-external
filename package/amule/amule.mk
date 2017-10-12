################################################################################
#
# amule
#
################################################################################

AMULE_SITE = https://github.com/amule-project/amule/archive/$(AMULE_VERSION).zip
AMULE_DEPENDENCIES = libcryptoxx wxwidgets
AMULE_LICENSE = BSD
AMULE_LICENSE_FILES = COPYING
AMULE_AUTOGEN = YES
AMULE_INSTALL_STAGING = YES

AMULE_CONF_OPTS = \
	--disable-nls  \
	--disable-ipv6 \
	--enable-shared \
	--disable-static \
	--disable-rpath \
	--with-gnu-ld \
	--disable-ccache \
	--disable-debug \
	--disable-optimize \
	--disable-profile \
	--disable-monolithic \
	--enable-amule-daemon \
	--enable-amulecmd \
	--disable-amulecmdgui \
	--disable-webserver \
	--disable-webservergui \
	--disable-amule-gui \
	--disable-cas \
	--disable-wxcas \
	--disable-ed2k \
	--disable-alc \
	--disable-alcc \
	--disable-systray \
	--disable-utf8-systray \
	--enable-embedded-crypto \
	--enable-gsocket \
	--disable-gtktest \
	--disable-crypto \
	--with-wxdir=$(WXWIDGETS_DIR) \
	--with-wx-prefix=$(WXWIDGETS_DIR)/lib \
	--with-wx-config=$(WXWIDGETS_DIR)/wx-config \
	--with-crypto-prefix=$(LIBCRYPTOXX_DIR)

define AMULE_INSTALL_START_SCRIPT
	rsync -au $(BR2_EXTERNAL_NETGEAR_PATH)/package/amule/etc/aMule $(TARGET_DIR)/etc/
endef

AMULE_POST_INSTALL_TARGET_HOOKS += AMULE_INSTALL_START_SCRIPT

$(eval $(autotools-package))
