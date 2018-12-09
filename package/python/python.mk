################################################################################
#
# python
#
################################################################################

PYTHON_SITE = https://python.org/ftp/python
PYTHON_LICENSE = Python-2.0, others
PYTHON_LICENSE_FILES = LICENSE
PYTHON_LIBTOOL_PATCH = NO

PYTHON_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_PACKAGE_PYTHON_READLINE),y)
PYTHON_DEPENDENCIES += readline
else
PYTHON_CONF_OPTS += --disable-readline
endif

ifeq ($(BR2_PACKAGE_PYTHON_CURSES),y)
PYTHON_DEPENDENCIES += ncurses
else
PYTHON_CONF_OPTS += --disable-curses
endif

ifeq ($(BR2_PACKAGE_PYTHON_PYEXPAT),y)
PYTHON_DEPENDENCIES += expat
PYTHON_CONF_OPTS += --with-expat=system
else
PYTHON_CONF_OPTS += --with-expat=none
endif

ifeq ($(BR2_PACKAGE_PYTHON_BSDDB),y)
PYTHON_DEPENDENCIES += berkeleydb
else
PYTHON_CONF_OPTS += --disable-bsddb
endif

ifeq ($(BR2_PACKAGE_PYTHON_SQLITE),y)
PYTHON_DEPENDENCIES += sqlite
else
PYTHON_CONF_OPTS += --disable-sqlite3
endif

ifeq ($(BR2_PACKAGE_PYTHON_SSL),y)
PYTHON_DEPENDENCIES += openssl
else
PYTHON_CONF_OPTS += --disable-ssl
endif

ifneq ($(BR2_PACKAGE_PYTHON_CODECSCJK),y)
PYTHON_CONF_OPTS += --disable-codecs-cjk
endif

ifneq ($(BR2_PACKAGE_PYTHON_UNICODEDATA),y)
PYTHON_CONF_OPTS += --disable-unicodedata
endif

# Default is UCS2 w/o a conf opt
ifeq ($(BR2_PACKAGE_PYTHON_UCS4),y)
PYTHON_CONF_OPTS += --enable-unicode=ucs4
endif

ifeq ($(BR2_PACKAGE_PYTHON_BZIP2),y)
PYTHON_DEPENDENCIES += bzip2
else
PYTHON_CONF_OPTS += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_PYTHON_ZLIB),y)
PYTHON_DEPENDENCIES += zlib
else
PYTHON_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_PYTHON_HASHLIB),y)
PYTHON_DEPENDENCIES += openssl
else
PYTHON_CONF_OPTS += --disable-hashlib
endif

ifeq ($(BR2_PACKAGE_PYTHON_OSSAUDIODEV),y)
PYTHON_CONF_OPTS += --enable-ossaudiodev
else
PYTHON_CONF_OPTS += --disable-ossaudiodev
endif

# Make python believe we don't have 'hg' and 'svn', so that it doesn't
# try to communicate over the network during the build.
PYTHON_CONF_ENV += \
	ac_cv_have_long_long_format=yes \
	ac_cv_file__dev_ptmx=yes \
	ac_cv_file__dev_ptc=yes \
	ac_cv_working_tzset=yes \
	ac_cv_prog_HAS_HG=/bin/false \
	ac_cv_prog_SVNVERSION=/bin/false

# GCC is always compliant with IEEE754
ifeq ($(BR2_ENDIAN),"LITTLE")
PYTHON_CONF_ENV += ac_cv_little_endian_double=yes
else
PYTHON_CONF_ENV += ac_cv_big_endian_double=yes
endif

PYTHON_CONF_OPTS += \
	--without-cxx-main \
	--without-doc-strings \
	--with-system-ffi \
	--disable-pydoc \
	--disable-test-modules \
	--disable-lib2to3 \
	--disable-gdbm \
	--disable-tk \
	--disable-nis \
	--disable-dbm \
	--disable-pyo-build \
	--disable-pyc-build

# This is needed to make sure the Python build process doesn't try to
# regenerate those files with the pgen program. Otherwise, it builds
# pgen for the target, and tries to run it on the host.

define PYTHON_TOUCH_GRAMMAR_FILES
	touch $(@D)/Include/graminit.h $(@D)/Python/graminit.c
endef

PYTHON_POST_PATCH_HOOKS += PYTHON_TOUCH_GRAMMAR_FILES

# Always install the python-config symlink in the staging tree
define PYTHON_INSTALL_STAGING_PYTHON_CONFIG_SYMLINK
	ln -sf python2-config $(STAGING_DIR)/usr/bin/python-config
endef

PYTHON_POST_INSTALL_STAGING_HOOKS += PYTHON_INSTALL_STAGING_PYTHON_CONFIG_SYMLINK

PYTHON_AUTORECONF = YES

# It's dependent only by samba4, don't install python actually
PYTHON_INSTALL_STAGING = YES
PYTHON_INSTALL_TARGET = NO

define PYTHON_INSTALL_STAGING_CMDS
	@true
endef

$(eval $(autotools-package))
