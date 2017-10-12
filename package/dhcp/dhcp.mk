################################################################################
#
# dhcp
#
################################################################################

DHCP_SITE = http://ftp.isc.org/isc/dhcp
DHCP_INSTALL_STAGING = YES
DHCP_AUTORECONF = YES
DHCP_LICENSE = ISC
DHCP_LICENSE_FILES = LICENSE

# bind does not support parallel builds.
DHCP_MAKE = $(MAKE1)

DHCP_CONF_ENV = \
	ac_cv_func_setpgrp_void=no \
	CFLAGS="-I$(BR2_TOPDIR)$(ROUTER)/shared"

# bind configure is called via dhcp make instead of dhcp configure. The make env
# needs extra values for bind configure.
DHCP_MAKE_ENV = \
	$(TARGET_CONFIGURE_OPTS) \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)" \
	BUILD_CPPFLAGS="$(HOST_CPPFLAGS)" \
	BUILD_LDFLAGS="$(HOST_LDFLAGS)"

define DHCP_REMOVE_INSTALL_OPTIONS
	$(SED) 's,-s -o bin -g bin,,' -e 's,-o bin -g bin,,' -e 's,-o root -g root,,' $(@D)/Makefile.in
endef
DHCP_PRE_CONFIGURE_HOOKS += DHCP_REMOVE_INSTALL_OPTIONS

$(eval $(autotools-package))
