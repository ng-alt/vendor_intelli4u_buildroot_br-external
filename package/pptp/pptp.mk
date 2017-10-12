################################################################################
#
# pptp
#
################################################################################

PPTP_LICENSE = GPL-2.0
PPTP_LICENSE_FILES = COPYING
PPTP_MAKE_OPTS = $(ROUTER_MAKE_OPTS)
PPTP_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) TARGETDIR=$(TARGET_DIR) install

define PPTP_INSTALL_WITHOUT_OWNER
	$(SED) 's/ -o root//g' $(@D)/Makefile
endef

PPTP_PRE_BUILD_HOOKS = PPTP_INSTALL_WITHOUT_OWNER ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

$(eval $(make-package))

