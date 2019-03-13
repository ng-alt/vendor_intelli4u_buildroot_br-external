################################################################################
#
# gdbm
#
################################################################################

GDBM_VERSION_FILE = configure.ac
GDBM_VERSION_PATTERN = "@(_GDBM_VERSION_MAJOR).@(_GDBM_VERSION_MINOR)"
GDBM_LICENSE = GPL-3.0+
GDBM_LICENSE_FILES = COPYING
GDBM_AUTOGEN = YES
GDBM_INSTALL_STAGING = YES
GDBM_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
GDBM_MAKE = $(MAKE1)

ifeq ($(BR2_PACKAGE_READLINE),y)
GDBM_CONF_OPTS += --with-readline
GDBM_DEPENDENCIES += readline
else
GDBM_CONF_OPTS += --without-readline
endif

# Not to install/compile the cracked data files
define GDBM_SUPPESS_COMPILATION
    $(SED) 's, po ,,' $(@D)/Makefile.am
endef
GDBM_PRE_CONFIGURE_HOOKS += GDBM_SUPPESS_COMPILATION

$(eval $(autotools-package))
