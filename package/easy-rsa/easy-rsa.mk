################################################################################
#
# easy-rsa
#
################################################################################

EASY_RSA_SITE = https://github.com/OpenVPN/easy-rsa/releases/download/$(EASY_RSA_VERSION)
EASY_RSA_LICENSE = GPL-2.0
EASY_RSA_LICENSE_FILES = COPYING gpl-2.0.txt

# shell script, so no build step

define EASY_RSA_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/rom/easy-rsa
	$(INSTALL) $(@D)/easy-rsa/2.0/* $(TARGET_DIR)/rom/easy-rsa
endef

$(eval $(generic-package))
