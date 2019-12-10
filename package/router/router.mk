################################################################################
#
# router
#
################################################################################

# refer to merlin version
ROUTER_VERSION_FILE = $(BR2_TOPDIR)vendor/asus/base/version.conf
ROUTER_VERSION_PATTERN = "SERIALNO\s*=\s*(.+)"
ROUTER_SITE = https://www.downloads.netgear.com/files/GPL
ROUTER_SOURCE = R6300v2-$(ROUTER_VERSION)_src.tar.zip
ROUTER_LICENSE = GPL-2.0
ROUTER_LICENSE_FILES = LICENSE
ROUTER_BUILD_CONFIG = $(ROUTER_DIR)/.config
ROUTER_RSYNC_OPTIONS = -au --copy-unsafe-links

ROUTER_MAKE = $(MAKE1)
ROUTER_KCONFIG_MAKE = $(MAKE1)

ROUTER_PREPARED_MAKE_OPTS = SRCBASE=$(SRC_BASE_DIR) \
	LINUX_DIR="$(LINUX_DIR)" LINUX_OUTDIR="$(LINUX_DIR)" \
	LINUXDIR=$(if $(LINUX_OVERRIDE2_SRCDIR),$(LINUX_OVERRIDE2_SRCDIR),$(LINUX_DIR))

ROUTER_DEPENDENCY_MAKE_OPTS = \
	CFLAGS="-I$(SRC_BASE_DIR)/include -I$(ROUTER_DIR)/shared" \
	LDFLAGS="-lgcc_s -L$(TARGET_DIR)/usr/lib -lnvram -lshared"

ROUTER_DEPENDENCY_MAKE_PLUS_OPTS = \
	CFLAGS+="-I$(SRC_BASE_DIR)/include -I$(ROUTER_DIR)/shared" \
	LDFLAGS+="-lgcc_s -L$(TARGET_DIR)/usr/lib -lnvram -lshared"

ROUTER_MAKE_OPTS = \
	CROSS_COMPILE=$(patsubst %-gcc,%-,$(notdir $(TARGET_CC))) \
	$(ROUTER_PREPARED_MAKE_OPTS) ROUTER_DIR="$(ROUTER_DIR)" \
	TOP="$(ROUTER_DIR)" ROUTER_DIR="$(ROUTER_DIR)" \
	IPTABLESDIR="$(IPTABLES_DIR)" \
	OPENSSLDIR="$(OPENSSL_DIR)" \
	ZLIBDIR="$(ZLIB_DIR)" \
	BUSYBOX_OUTDIR="$(BUSYBOX_DIR)" BUSYBOXDIR="$(if $(BUSYBOX_OVERRIDE2_SRCDIR),$(BUSYBOX_OVERRIDE2_SRCDIR),$(BUSYBOX_DIR))"

ROUTER_VENDOR = $(call qstrip,$(BR2_PACKAGE_ROUTER_VENDOR))
ROUTER_KCONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_ROUTER_CONFIG))
ROUTER_AUTOCONF_FILE = $(call qstrip,$(BR2_PACKAGE_ROUTER_AUTOCONF))

ROUTER_DEPENDENCIES += busybox
ROUTER_DEPENDENCIES += linux
ROUTER_DEPENDENCIES += src-base
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_JSON_C), json-c)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBCURL), libcurl)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBUSB), libusb)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBXML2), libxml2)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_OPENSSL), openssl)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_SQLITE), sqlite)
ROUTER_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB), zlib)

define ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE
	$(SED) '/^include\s\+.*config/ { s|include \(..\/\)\{1,\}|include $(ROUTER_DIR)\/|g }' $(if $(1),$(1),$(@D)/Makefile)
	$(SED) '/^include\s\+.*common.mak/ { s|include \(..\/\)\{1,\}|include $(ROUTER_DIR)/.config $(ROUTER_DIR)\/|g }' $(if $(1),$(1),$(@D)/Makefile)
endef

define ROUTER_ALL_MAKEFILES_INCLUDE_SUPPRESS_SUBROUTINE
	find $(@D) -name 'Makefile' -exec $(SED) '/^include\s\+.*config\./ { s|include \(..\/\)\{1,\}|include $(BR2_EXTERNAL_NETGEAR_PATH)/package/router/src\/|g }' {} \;
endef

ROUTER_PJPROJECT_CONFIGURE = asusnatnl/pjproject-1.12/configure-router-arm
define ROUTER_FIX_ASUSNATL_PJPROJECT_CONFIGURE
	if [ -e $(@D)/$(ROUTER_PJPROJECT_CONFIGURE) ] ; then \
		$(SED) "s,OPENSSL_LDLIBS=\"-lssl,OPENSSL_LDLIBS=\"-L$$TARGET_DIR/usr/lib -lssl," \
			-e "/OPENSSL_DIR=/D" $(@D)/$(ROUTER_PJPROJECT_CONFIGURE); \
	fi
endef
ROUTER_PRE_BUILD_HOOKS += ROUTER_FIX_ASUSNATL_PJPROJECT_CONFIGURE

# Set for linux kernel to build compressed kernel with vendor reference. As linux is built
# before package router, add the dependencies to rsync this package.
LINUX_DEPENDENCIES += router-configure
define ROUTER_BUILD_BOOT_IMAGE
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(ROUTER_DIR)/compressed $(ROUTER_MAKE_OPTS) all && \
		cp $(ROUTER_DIR)/compressed/vmlinuz $(BINARIES_DIR)/
endef
LINUX_POST_INSTALL_IMAGES_HOOKS += ROUTER_BUILD_BOOT_IMAGE

define ROUTER_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) \
		HOST=_LINUX $(ROUTER_MAKE_OPTS) all
endef

define ROUTER_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) \
		$(ROUTER_MAKE_OPTS) INSTALLFLAGS=-m755 install
	rsync -au $(@D)/arm-uclibc/target $(BASE_DIR)
	cd $(@D)/compressed && $(TARGET_CONFIGURE_OPTS) $(MAKE1) $(ROUTER_MAKE_OPTS) all && cp vmlinuz $(BINARIES_DIR)/
	$(INSTALL) -D -m 0500 $(@D)/httpd/gencert.sh $(TARGET_DIR)/usr/sbin/gencert.sh
	for ko in $(TARGET_DIR)/lib/modules/*/kernel/fs/*.ko ; do \
		for prep in tfat.ko thfsplus.ko tntfs.ko ; do \
			if echo $$ko | grep -q $$prep ; then \
				$(BR2_EXTERNAL_NETGEAR_PATH)/scripts/patch_kobj_version.py -v $$ko $(LINUX_DIR)/Module.symvers; \
			fi; \
		done; \
	done
endef

ifeq ($(BR2_PACKAGE_ROUTER),y)
ifeq ($(call qstrip,$(BR2_PACKAGE_ROUTER_CONFIG)),)
$(error No router configuration file specified, check your BR2_PACKAGE_ROUTER_CONFIG setting)
endif
endif

ifneq ($(BR2_PACKAGE_EMAIL),y)
define ROUTER_SET_EMAIL
	$(call KCONFIG_DISABLE_OPT,RTCONFIG_PUSH_EMAIL,$(ROUTER_BUILD_CONFIG))
endef
endif

ifneq ($(BR2_PACKAGE_6RELAYD),y)
define ROUTER_SET_6RELAY
	$(call KCONFIG_DISABLE_OPT,RTCONFIG_6RELAYD,$(ROUTER_BUILD_CONFIG))
endef
endif

ifneq ($(ROUTER_AUTOCONF_FILE),)
define ROUTER_UPDATE_AUTOCONF_FILE
	if [ -e $(@D)/include/autoconf.h ] && [ $(ROUTER_AUTOCONF_FILE) != include/autoconf.h ] ; then \
		mkdir -p $(dir $(@D)/$(ROUTER_AUTOCONF_FILE)); \
		rm -f $(@D)/$(ROUTER_AUTOCONF_FILE); \
		ln -sf $(@D)/include/autoconf.h $(@D)/$(ROUTER_AUTOCONF_FILE); \
	fi
endef
endif

define ROUTER_KCONFIG_FIXUP_CMDS
	$(ROUTER_SET_EMAIL)
	$(ROUTER_SET_6RELAY)
	$(ROUTER_UPDATE_AUTOCONF_FILE)
endef

$(eval $(kconfig-package))
