################################################################################
#
# libcryptoxx
#
################################################################################

LIBCRYPTOXX_SITE = https://www.cryptopp.com
LIBCRYPTOXX_INSTALL_STAGING = YES
LIBCRYPTOXX_INSTALL_STAGING_OPTS = PREFIX=$(STAGING_DIR) install
LIBCRYPTOXX_INSTALL_TARGET = NO

$(eval $(make-package))
