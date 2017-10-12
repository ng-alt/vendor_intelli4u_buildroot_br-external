################################################################################
#
# libiconv
#
################################################################################

LIBICONV_SITE = $(BR2_GNU_MIRROR)/libiconv
LIBICONV_LICENSE = GPL-3.0+ (iconv program), LGPL-2.0+ (library)
LIBICONV_LICENSE_FILES = COPYING COPYING.LIB
LIBICONV_AUTOGEN = YES
LIBICONV_AUTOGEN_ENV = GNULIB_TOOL=$(BR2_TOPDIR)/external/gnulib/gnulib-tool
#LIBICONV_AUTOGEN_OPTS = --skip-gnulib

# Don't build the preloadable library, as we don't need it (it's only
# for LD_PRELOAD to replace glibc's iconv, but we never build libiconv
# when glibc is used). And it causes problems for static only builds.
define LIBICONV_WASH_OUT_PACKAGE
	rm -f $(@D)/gnulib-local/lib/*.diff
	$(SED) '/preload/d' $(@D)/Makefile.in
	$(SED) '/ po /d' $(@D)/Makefile.in
	$(SED) 's/\-2.68//g' $(@D)/Makefile.devel $(@D)/libcharset/Makefile.devel $(@D)/preload/Makefile.devel
endef
LIBICONV_PRE_CONFIGURE_HOOKS += LIBICONV_WASH_OUT_PACKAGE

define LIBICONV_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/lib/.libs/libiconv.so.2.5.1 $(TARGET_DIR)/usr/lib/libiconv.so.2.5.1
	ln -sf libiconv.so.2.5.1 $(TARGET_DIR)/usr/lib/libiconv.so
	ln -sf libiconv.so.2.5.1 $(TARGET_DIR)/usr/lib/libiconv.so.2
endef

$(eval $(autotools-package))

# Configurations where the toolchain supports locales and the libiconv
# package is enabled are incorrect, because the toolchain already
# provides libiconv functionality, and having both confuses packages.
ifeq ($(BR2_PACKAGE_LIBICONV)$(BR2_ENABLE_LOCALE),yy)
$(error Libiconv should never be enabled when the toolchain supports locales. Report this failure to Buildroot developers)
endif
