################################################################################
#
# libgcrypt
#
################################################################################

GDBM_VERSION_FILE = configure.ac
GDBM_VERSION_PATTERN = "@(mym4_version_major).@(mym4_version_minor).@(mym4_version_micro)"
LIBGCRYPT_LICENSE = LGPL-2.1+
LIBGCRYPT_LICENSE_FILES = COPYING.LIB
LIBGCRYPT_SITE = https://gnupg.org/ftp/gcrypt/libgcrypt
LIBGCRYPT_AUTOGEN = YES
LIBGCRYPT_INSTALL_STAGING = YES
LIBGCRYPT_DEPENDENCIES = libgpg-error
LIBGCRYPT_CONFIG_SCRIPTS = libgcrypt-config

LIBGCRYPT_CONF_ENV = \
	ac_cv_sys_symbol_underscore=no
LIBGCRYPT_CONF_OPTS = \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr

# Libgcrypt doesn't support assembly for coldfire
ifeq ($(BR2_m68k_cf),y)
LIBGCRYPT_CONF_OPTS += --disable-asm
endif

# Code doesn't build in thumb mode
ifeq ($(BR2_arm),y)
LIBGCRYPT_CONF_ENV += CFLAGS="$(patsubst -mthumb,,$(TARGET_CFLAGS))"
endif

# Tests use fork()
define LIBGCRYPT_DISABLE_SUBDIR
	$(SED) 's/ doc tests//' $(@D)/Makefile.am
endef

LIBGCRYPT_PRE_CONFIGURE_HOOKS += LIBGCRYPT_DISABLE_SUBDIR

$(eval $(autotools-package))
