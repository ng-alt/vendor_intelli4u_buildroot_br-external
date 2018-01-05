L7PROTOCOLS_LICENSE = GPLv2
L7PROTOCOLS_LICENSE_FILES = LICENSE

L7PROTOCOLS_TARGET_PATH=$(call qstrip,$(BR2_TARGET_L7PROTOCOLS_PATH))

define L7PROTOCOLS_INSTALL_TARGET_CMDS
	@mkdir -p $(TARGET_DIR)/$(L7PROTOCOLS_TARGET_PATH); \
	count=0; \
	for pat in $(@D)/*/*.pat ; do \
		echo -en "l7protocols: Squash $${pat##*/} ...               \r"; \
		grep -v -Pe '^\s*$|^#|^userspace ' $$pat > $(TARGET_DIR)/$(L7PROTOCOLS_TARGET_PATH)/$${pat##*/}; \
		((count++)); \
	done; \
	echo -e "\r"; \
	echo "l7protocols: $$count files handled"
endef

$(eval $(generic-package))

