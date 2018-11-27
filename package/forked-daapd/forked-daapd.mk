################################################################################
#
# forked-daapd
#
################################################################################

FORKED_DAAPD_MAKE = $(MAKE1)
FORKED_DAAPD_LICENSE = GPLv2
FORKED_DAAPD_LICENSE_FILES = COPYING
FORKED_DAAPD_DEPENDENCIES = gdbm libid3tag

FORKED_DAAPD_MAKE_ENV=INSTALLDIR=$(TARGET_DIR)

$(eval $(make-package))
