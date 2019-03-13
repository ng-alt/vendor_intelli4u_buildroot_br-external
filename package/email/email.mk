################################################################################
#
# email
#
################################################################################

EMAIL_LICENSE = GPLv2
EMAIL_AUTORECONF = YES

define EMAIL_DLIB_CONFIGURATION
	cd $(@D)/dlib && \
	autoreconf -fi && \
	$(TARGET_CONFIGURE_OPTS) $(TARGET_CONFIGURE_ARGS) ./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME)
endef

EMAIL_PRE_CONFIGURE_HOOKS += EMAIL_DLIB_CONFIGURATION

define EMAIL_INSTALL_TARGET_CMDS
	$(INSTALL) $(@D)/src/email $(TARGET_DIR)/usr/sbin/email
endef

$(eval $(autotools-package))
