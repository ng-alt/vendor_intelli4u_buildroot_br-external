################################################################################
#
# sdparm
#
################################################################################

SDPARM_LICENSE = BSD-3-Clause
SDPARM_LICENSE_FILES = COPYING
SDPARM_AUTOGEN = YES

ifeq ($(BR2_PACKAGE_SG3_UTILS),y)
SDPARM_DEPENDENCIES += sg3_utils
else
SDPARM_CONF_OPTS += --disable-libsgutils
endif

$(eval $(autotools-package))
