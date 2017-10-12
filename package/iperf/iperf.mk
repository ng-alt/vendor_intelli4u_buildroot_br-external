################################################################################
#
# iperf
#
################################################################################

IPERF_SITE = http://downloads.sourceforge.net/project/iperf2
IPERF_LICENSE = MIT-like
IPERF_LICENSE_FILES = COPYING
IPERF_AUTOGEN = YES

IPERF_CONF_ENV = \
	ac_cv_func_malloc_0_nonnull=yes

IPERF_CONF_OPTS = \
	--disable-web100 \
	--disable-pam-dlopen \
	--disable-plugin-auth-pam

define IPERF_DISABLE_INSTALLATION
    $(SED) 's/SUBDIRS = compat doc include src man/SUBDIRS = compat include src/' \$(@D)/Makefile.am
endef
IPERF_PRE_CONFIGURE_HOOKS += IPERF_DISABLE_INSTALLATION

$(eval $(autotools-package))
