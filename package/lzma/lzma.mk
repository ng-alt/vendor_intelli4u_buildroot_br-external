################################################################################
#
# lzma
#
################################################################################

LZMA_LICENSE = LGPL-2.1 or GPL-3.0
LZMA_LICENSE_FILES = COPYING.LGPLv2.1 COPYING.GPLv3
LZMA_SITE = http://tukaani.org/lzma
LZMA_AUTOGEN = YES

$(eval $(host-autotools-package))

LZMA = $(HOST_DIR)/bin/lzma
