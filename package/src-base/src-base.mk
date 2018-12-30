################################################################################
#
# src-base
#
################################################################################

SRC_BASE_REF_DIR = $(BR2_TOPDIR)vendor/asus/base
SRC_BASE_VERSION_FILE = $(BR2_TOPDIR)vendor/netgear/acos/include/ambitCfg.h
SRC_BASE_VERSION_PATTERN = "\#\s*define\s+AMBIT_SOFTWARE_VERSION\s+\"([^\"]+)\""

SRC_BASE_MAKE = $(MAKE1)

SRC_BASE_OVERRIDED_TARGET = $(call qstrip,$(BR2_PACKAGE_SRC_BASE_OVERRIDED_TARGET))
# build the referred .config with original asus solution.
# target.mak contains the initial configuration for router variants and the overrided
# includes the patches for the file. Append profile.merlin.alt.mak to profile.mak to
# adjust some configurations
define SRC_BASE_BUILD_CMDS
	for script in platform.mak profile.mak target.mak version.conf ; do \
		rsync -au $(SRC_BASE_REF_DIR)/$$script $(@D)/; \
	done

	if [ -n "$(SRC_BASE_OVERRIDED_TARGET)" ] ; then \
		echo "" >> $(@D)/target.mak; \
		cat $(SRC_BASE_OVERRIDED_TARGET) >> $(@D)/target.mak; \
	fi

	rsync -au $(SRC_BASE_REF_DIR)/Makefile $(@D)/Makefile.asus && \
		$(SED) '/$$(MAKE) bin/d' -e 's,router/,./,g' $(@D)/Makefile.asus && \
		make -C $(@D) -f Makefile.asus rt_ver $(BUILD_NAME) LINUXDIR=$(LINUX_DIR)
endef

$(eval $(generic-package))

