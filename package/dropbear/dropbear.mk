################################################################################
#
# dropbear
#
################################################################################

DROPBEAR_VERSION_FILE = sysoptions.h
DROPBEAR_VERSION_PATTERN = "\#\s*define\s+DROPBEAR_VERSION\s+\"([^\"]+)\""
DROPBEAR_LICENSE = MIT, BSD-2-Clause-like, BSD-2-Clause
DROPBEAR_LICENSE_FILES = LICENSE
DROPBEAR_TARGET_BINS = dropbearkey dropbearconvert scp
DROPBEAR_PROGRAMS = dropbear $(DROPBEAR_TARGET_BINS)
DROPBEAR_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_DROPBEAR_CLIENT),y)
# Build dbclient, and create a convenience symlink named ssh
DROPBEAR_PROGRAMS += dbclient
DROPBEAR_TARGET_BINS += dbclient ssh
endif

DROPBEAR_MAKE = \
	$(MAKE) MULTI=1 SCPPROGRESS=1 \
	PROGRAMS="$(DROPBEAR_PROGRAMS)"

ifeq ($(BR2_STATIC_LIBS),y)
DROPBEAR_MAKE += STATIC=1
endif

define DROPBEAR_FIX_XAUTH
	$(SED) 's,^#define XAUTH_COMMAND.*/xauth,#define XAUTH_COMMAND "/usr/bin/xauth,g' $(@D)/options.h
endef

DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_FIX_XAUTH

define DROPBEAR_ENABLE_REVERSE_DNS
	$(SED) 's:.*\(#define DO_HOST_LOOKUP\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_BUILD_SMALL
	$(SED) 's:.*\(#define NO_FAST_EXPTMOD\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_BUILD_FEATURED
	$(SED) 's:^#define DROPBEAR_SMALL_CODE::' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_BLOWFISH\).*:\1:' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_TWOFISH128\).*:\1:' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_TWOFISH256\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_DISABLE_STANDALONE
	$(SED) 's:\(#define NON_INETD_MODE\):/*\1 */:' $(@D)/options.h
endef

ifeq ($(BR2_PACKAGE_DROPBEAR_DISABLE_REVERSEDNS),)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_ENABLE_REVERSE_DNS
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_SMALL),y)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_BUILD_SMALL
DROPBEAR_CONF_OPTS += --disable-zlib
else
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_BUILD_FEATURED
DROPBEAR_DEPENDENCIES += zlib
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_WTMP),y)
DROPBEAR_CONF_OPTS += --disable-wtmp
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_LASTLOG),y)
DROPBEAR_CONF_OPTS += --disable-lastlog
endif

define DROPBEAR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/dropbearmulti $(TARGET_DIR)/usr/sbin/dropbearmulti
	for f in $(DROPBEAR_PROGRAMS); do \
		ln -snf ../sbin/dropbearmulti $(TARGET_DIR)/usr/bin/$$f ; \
	done
endef

$(eval $(autotools-package))
