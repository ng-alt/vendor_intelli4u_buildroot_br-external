################################################################################
#
# vsftpd
#
################################################################################

VSFTPD_LIBS = -lcrypt
VSFTPD_LICENSE = GPL-2.0
VSFTPD_LICENSE_FILES = COPYING
VSFTPD_DEPENDENCIES = router

define VSFTPD_DISABLE_UTMPX
	$(SED) 's/.*VSF_BUILD_UTMPX/#undef VSF_BUILD_UTMPX/' $(@D)/builddefs.h
endef

define VSFTPD_ENABLE_SSL
	cp $(@D)/builddefs-ssl.h $(@D)/builddefs.h
	$(SED) 's/.*VSF_BUILD_SSL/#define VSF_BUILD_SSL/' $(@D)/builddefs.h
endef

define VSFTPD_DISABLE_SSL
	cp $(@D)/builddefs-nossl.h $(@D)/builddefs.h
endef

ifeq ($(BR2_PACKAGE_OPENSSL),y)
VSFTPD_DEPENDENCIES += openssl host-pkgconf
VSFTPD_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs libssl libcrypto`
VSFTPD_POST_CONFIGURE_HOOKS += VSFTPD_ENABLE_SSL
else
VSFTPD_POST_CONFIGURE_HOOKS += VSFTPD_DISABLE_SSL
endif

ifeq ($(BR2_PACKAGE_VSFTPD_UTMPX),)
VSFTPD_POST_CONFIGURE_HOOKS += VSFTPD_DISABLE_UTMPX
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
VSFTPD_DEPENDENCIES += libcap
VSFTPD_LIBS += -lcap
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
VSFTPD_DEPENDENCIES += linux-pam
VSFTPD_LIBS += -lpam
endif

VSFTPD_PRE_BUILD_HOOKS += ROUTER_MAKEFILE_INCLUDE_SUPPRESS_SUBROUTINE

define VSFTPD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" LIBS="$(VSFTPD_LIBS)" \
		ROUTER_DIR="$(ROUTER_DIR)" OPENSSLDIR="$(OPENSSL_DIR)" SRCBASE="$(SRC_BASE_DIR)" \
		TOP="$(if $(ROOTDIR),$(ROUTER_DIR),$(TOP))" \
		LINUXDIR=$(if $(LINUX_OVERRIDE2_SRCDIR),$(LINUX_OVERRIDE2_SRCDIR),$(LINUX_DIR)) \
		-C $(@D) vsftpd
endef

# vsftpd won't work if the jail directory is writable, it has to be
# readable only otherwise you get the following error:
# 500 OOPS: vsftpd: refusing to run with writable root inside chroot()
# That's why we have to adjust the permissions of /home/ftp
define VSFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/vsftpd $(TARGET_DIR)/usr/sbin/vsftpd
	test -f $(TARGET_DIR)/etc/vsftpd.conf || \
		$(INSTALL) -D -m 644 $(@D)/vsftpd.conf \
			$(TARGET_DIR)/etc/vsftpd.conf
endef

$(eval $(generic-package))
