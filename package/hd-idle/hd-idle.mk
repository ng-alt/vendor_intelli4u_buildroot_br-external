################################################################################
#
# hd-idle
#
################################################################################

HD_IDLE_SITE = http://hd-idle.sf.net
HD_IDLE_LICENSE = GPL-2.0
HD_IDLE_LICENSE_FILES = LICENSE

HD_IDLE_MAKE_ENV) = \
	LIB_DIRS="-L$(shell dirname `$(TARGET_CC) -print-libgcc-file-name`)" \
	LIBS="-lgcc -lc -lm"
HD_IDLE_INSTALL_TARGET_OPTS = TARGETDIR=$(TARGET_DIR) install

define HD_IDLE_NOT_INSTALL_MAN_PAGES
	$(SED) '/\/share\/man\/man1\//d' $(@D)/Makefile
endef

HD_IDLE_PRE_CONFIGURE_HOOKS += HD_IDLE_NOT_INSTALL_MAN_PAGES

$(eval $(make-package))
