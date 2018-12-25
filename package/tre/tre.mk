################################################################################
#
# tre
#
################################################################################

TRE_SITE = http://laurikari.net/tre
TRE_CONF_OPTS = --disable-ldconfig
TRE_AUTOGEN = YES
TRE_AUTOGEN_SCRIPT = utils/autogen.sh
TRE_INSTALL_STAGING = YES
TRE_LICENSE = BSD
TRE_LICENSE_FILES = LICENSE

define TRE_AUTO_SCRIPTS_FIXUP
	$(SED) "s,^darcs,#darcs,g" $(@D)/utils/autogen.sh
endef
TRE_PRE_CONFIGURE_HOOKS += TRE_AUTO_SCRIPTS_FIXUP

$(eval $(autotools-package))
