################################################################################
#
# libvorbis
#
################################################################################

LIBVORBIS_SITE = http://downloads.xiph.org/releases/vorbis
LIBVORBIS_AUTOGEN = YES
LIBVORBIS_INSTALL_STAGING = YES
LIBVORBIS_CONF_OPTS = --disable-oggtest
LIBVORBIS_DEPENDENCIES = host-pkgconf libogg
LIBVORBIS_LICENSE = BSD-3-Clause
LIBVORBIS_LICENSE_FILES = COPYING

define LIBVORBIS_DISABLE_UNNEEDED
	$(SED) 's/SUBDIRS = m4 include vq lib examples test doc/SUBDIRS = m4 include vq lib/' $(@D)/Makefile.am
endef
LIBVORBIS_PRE_CONFIGURE_HOOKS += LIBVORBIS_DISABLE_UNNEEDED

$(eval $(autotools-package))
