################################################################################
#
# wxwidgets
#
################################################################################

WXWIDGETS_SITE = https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-$(WXWIDGETS_VERSION).tar.bz2
WXWIDGETS_LICENSE = BSD
WXWIDGETS_LICENSE_FILES = COPYING
WXWIDGETS_INSTALL_STAGING = YES

WXWIDGETS_CONF_OPTS = \
    --disable-gui \
    --enable-unicode

$(eval $(autotools-package))
