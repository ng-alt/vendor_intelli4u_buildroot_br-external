################################################################################
#
# geoip
#
################################################################################

GEOIP_SITE = https://github.com/maxmind/geoip-api-c/releases/download
GEOIP_AUTOGEN = YES
GEOIP_AUTOGEN_SCRIPT = bootstrap
GEOIP_INSTALL_STAGING = YES
GEOIP_LICENSE = LGPL-2.1+
GEOIP_LICENSE_FILES = COPYING

define GEOIP_ADD_MISSED_FILES
	rsync -au $(BR2_EXTERNAL_NETGEAR_PATH)/package/geoip/GeoIP.dat \
		    $(@D)/data/GeoIP.dat
endef
GEOIP_PRE_CONFIGURE_HOOKS += GEOIP_ADD_MISSED_FILES

$(eval $(autotools-package))
