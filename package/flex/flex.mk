################################################################################
#
# flex
#
################################################################################

FLEX_SITE = https://github.com/westes/flex/files/981163
FLEX_LICENSE = FLEX
FLEX_LICENSE_FILES = COPYING
FLEX_AUTORECONF = YES
FLEX_AUTOMAKE = YES
FLEX_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) host-m4
FLEX_INSTALL_STAGING = YES
FLEX_INSTALL_TARGET = NO
FLEX_CONF_ENV = ac_cv_path_M4=/usr/bin/m4

define FLEX_DISABLE_INSTALLATION
	$(SED) 's,install: $$(FLEX) $$(FLEXLIB) installdirs install.$$(INSTALLMAN),install: $$(FLEX) $$(FLEXLIB),' \
		-e 's,@prefix@,$$(DESTDIR)/usr,' \
		-e 's,@exec_prefix@,$$(DESTDIR)/usr,' $(@D)/Makefile.in
endef
FLEX_PRE_CONFIGURE_HOOKS += FLEX_DISABLE_INSTALLATION

define FLEX_ADD_MISSED_FILES
	rsync -au $(BR2_EXTERNAL_NETGEAR_PATH)/package/flex/initscan.c \
		    $(@D)/initscan.c
endef
FLEX_PRE_CONFIGURE_HOOKS += FLEX_ADD_MISSED_FILES

# flex++ symlink is broken when flex binary is not installed
define FLEX_REMOVE_BROKEN_SYMLINK
	rm -f $(TARGET_DIR)/usr/bin/flex++
endef
FLEX_POST_INSTALL_TARGET_HOOKS += FLEX_REMOVE_BROKEN_SYMLINK

$(eval $(autotools-package))
