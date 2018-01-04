################################################################################
#
# gperf
#
################################################################################

GPERF_SITE = $(BR2_GNU_MIRROR)/gperf
GPERF_VERSION_FILE = src/version.cc
GPERF_LICENSE = GPL-3.0+
GPERF_LICENSE_FILES = COPYING

define GPERF_SUPPRESS_COMPILATION
	$(SED) '/^s\/@subdir@\/tests\/$$/ {N; N; s/s\/@subdir@\/tests\/\np\ng//g}' \
		-e '/^s\/@subdir@\/doc\/$$/ {N; N; s/s\/@subdir@\/doc\/\np\nd//g}' \
		-e '/^s\/@subdir@\/src\/$$/ {N; N; s/s\/@subdir@\/src\/\np\ng/s\/@subdir@\/src\/\np\nd/g}' \
		$(@D)/configure
endef
GPERF_PRE_CONFIGURE_HOOKS += GPERF_SUPPRESS_COMPILATION

$(eval $(autotools-package))
