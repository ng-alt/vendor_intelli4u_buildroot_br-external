################################################################################
#
# iproute2
#
################################################################################

IPROUTE2_VERSION_FILE = $(BR2_TOPDIR)external/iproute2/include/SNAPSHOT.h
IPROUTE2_VERSION_PATTERN = "static\s+char\s+SNAPSHOT\[]\s*=\s*\"(\d+)\";"
IPROUTE2_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/net/iproute2
IPROUTE2_DEPENDENCIES = host-bison host-flex host-pkgconf \
	$(if $(BR2_PACKAGE_LIBMNL),libmnl)
IPROUTE2_LICENSE = GPL-2.0+
IPROUTE2_LICENSE_FILES = COPYING

IPROUTE2_PRE_BUILD_HOOKS = ROUTER_ALL_MAKEFILES_INCLUDE_SUPPRESS_SUBROUTINE

# If both iproute2 and busybox are selected, make certain we win
# the fight over who gets to have their utils actually installed.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
IPROUTE2_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
IPROUTE2_DEPENDENCIES += elfutils
endif

# If we've got iptables enable xtables support for tc
ifeq ($(BR2_PACKAGE_IPTABLES)x$(BR2_STATIC_LIBS),yx)
IPROUTE2_DEPENDENCIES += iptables
define IPROUTE2_WITH_IPTABLES
	# Makefile is busted so it never passes IPT_LIB_DIR properly
	$(SED) "s/-DIPT/-DXT/" $(@D)/tc/Makefile
endef
else
define IPROUTE2_WITH_IPTABLES
	# em_ipset needs xtables, but configure misdetects it
	echo "TC_CONFIG_IPSET:=n" >>$(@D)/Config
	echo "TC_CONFIG_XT:=n" >>$(@D)/Config
endef
endif

# arpd needs BerkeleyDB and links against pthread
ifeq ($(BR2_PACKAGE_BERKELEYDB_COMPAT185)$(BR2_TOOLCHAIN_HAS_THREADS),yy)
IPROUTE2_DEPENDENCIES += berkeleydb
else
define IPROUTE2_DISABLE_ARPD
	echo "HAVE_BERKELEY_DB:=n" >> $(@D)/Config
endef
endif

# ifcfg needs bash
ifeq ($(BR2_PACKAGE_BASH),)
define IPROUTE2_REMOVE_IFCFG
	rm -f $(TARGET_DIR)/sbin/ifcfg
endef
endif

define IPROUTE2_SUPPRESS_TARGET
	$(SED) 's/SUBDIRS=lib ip tc bridge misc netem genl man/SUBDIRS=lib ip tc/' $(@D)/Makefile
endef

define IPROUTE2_BUILD_CMDS
	$(IPROUTE2_DISABLE_ARPD)
	$(IPROUTE2_WITH_IPTABLES)
	$(IPROUTE2_SUPPRESS_TARGET)
	$(SED) 's/$$(CCOPTS)//' $(@D)/netem/Makefile
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) \
		DBM_INCLUDE="$(STAGING_DIR)/usr/include" \
		CCOPTS="$(TARGET_CFLAGS) -D_GNU_SOURCE -DCONFIG_KERNEL_2_6_36" \
		SHARED_LIBS="$(if $(BR2_STATIC_LIBS),n,y)" -C $(@D)
endef

define IPROUTE2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" \
		SBINDIR=/sbin \
		DOCDIR=/usr/share/doc/iproute2-$(IPROUTE2_VERSION) \
		MANDIR=/usr/share/man install
	$(IPROUTE2_REMOVE_IFCFG)
endef

$(eval $(autotools-package))
