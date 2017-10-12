################################################################################
#
# libdaemon
#
################################################################################

LIBDAEMON_SITE = http://0pointer.de/lennart/projects/libdaemon
LIBDAEMON_LICENSE = LGPL-2.1+
LIBDAEMON_LICENSE_FILES = LICENSE
LIBDAEMON_INSTALL_STAGING = YES
LIBDAEMON_CONF_ENV = ac_cv_func_setpgrp_void=no
LIBDAEMON_CONF_OPTS = --disable-lynx
LIBDAEMON_DEPENDENCIES = host-pkgconf
LIBDAEMON_AUTOGEN = YES
LIBDAEMON_AUTOGEN_SCRIPT = bootstrap.sh

$(eval $(autotools-package))
