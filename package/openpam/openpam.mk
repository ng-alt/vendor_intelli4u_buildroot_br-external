################################################################################
#
# openpam
#
################################################################################

OPENPAM_LICENSE = ​3-clause BSD license
OPENPAM_AUTOGEN = YES

define OPENPAM_UPDATE_AUTO_SCRIPT
	$(SED) 's,autoconf,autoreconf -fi,' $(@D)/autogen.sh
endef
OPENPAM_PRE_CONFIGURE_HOOKS += OPENPAM_UPDATE_AUTO_SCRIPT

$(eval $(autotools-package))
