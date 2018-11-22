################################################################################
#
# src-base
#
################################################################################

# refer to merlin version
SRC_BASE_REF_DIR = $(BR2_TOPDIR)vendor/asus/base
SRC_BASE_VERSION_FILE = $(SRC_BASE_REF_DIR)/version.conf
SRC_BASE_VERSION_PATTERN = "SERIALNO\s*=\s*(.+)"
SRC_BASE_LICENSE = GPL-2.0
SRC_BASE_LICENSE_FILES = LICENSE

SRC_BASE_MAKE = $(MAKE1)

define SRC_BASE_BUILD_CMDS
	for script in platform.mak profile.mak target.mak version.conf ; do \
		rsync -au $(SRC_BASE_REF_DIR)/$$script $(@D)/; \
	done

	rsync -au $(SRC_BASE_REF_DIR)/Makefile $(@D)/Makefile.asus && \
		$(SED) '/$$(MAKE) bin/d' -e 's,router/,./,g' $(@D)/Makefile.asus && \
		make -C $(@D) -f Makefile.asus rt_ver $(BUILD_NAME) LINUXDIR=$(LINUX_DIR)
endef

$(eval $(generic-package))

