################################################################################
#
# berkeleydb
#
################################################################################

# Since BerkeleyDB version 6 and above are licensed under the Affero
# GPL (AGPL), we want to keep this 'bdb' package at version 5.x to
# avoid licensing issues.
# BerkeleyDB version 6 or above should be provided by a dedicated
# package instead.

BERKELEYDB_SITE = http://download.oracle.com/berkeley-db
BERKELEYDB_VERSION_FILE = dist/configure
BERKELEYDB_LICENSE = BerkeleyDB License
BERKELEYDB_LICENSE_FILES = LICENSE
BERKELEYDB_INSTALL_STAGING = YES
BERKELEYDB_BINARIES = db_archive db_checkpoint db_deadlock db_dump \
	db_hotbackup db_load db_log_verify db_printlog db_recover db_replicate \
	db_stat db_tuner db_upgrade db_verify db_codegen

BERKELEYDB_SUBDIR = build_unix

# Internal error, aborting at dw2gencfi.c:214 in emit_expr_encoded
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79509
ifeq ($(BR2_m68k_cf),y)
BERKELEYDB_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -fno-dwarf2-cfi-asm"
endif

define BERKELEYDB_SYNC_ARCH_BUILD_FILE
	rsync -au --chmod=u=rwX,go=rX $(BR2_EXTERNAL_NETGEAR_PATH)/package/berkeleydb/build_arm $(@D)
endef

define BERKELEYDB_DIST_CONFIGURE
	cd $(@D)/$(BERKELEYDB_SUBDIR) && \
	$(TARGET_CONFIGURE_OPTS) \
	../dist/configure --prefix=/usr \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--enable-cxx CFLAGS="-Os" \
		--disable-cryptography \
		--disable-hash \
		--disable-queue \
		--disable-replication \
		--disable-statistics \
		--disable-verify \
		--disable-compat185 \
		--disable-cxx \
		--disable-diagnostic \
		--disable-dump185 \
		--disable-java \
		--disable-mingw \
		--disable-o_direct \
		--enable-posixmutexes \
		--disable-smallbuild \
		--disable-tcl \
		--disable-test \
		--disable-uimutexes \
		--enable-umrw \
		--disable-static \
		--disable-libtool-lock
endef

BERKELEYDB_PRE_CONFIGURE_HOOKS += BERKELEYDB_DIST_CONFIGURE

define BERKELEYDB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$(BERKELEYDB_SUBDIR) \
                BERKELEYDB_DIR="$(BERKELEYDB_DIR)" DESTDIR="$(TARGET_DIR)" all
endef

define BERKELEYDB_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$(BERKELEYDB_SUBDIR) \
		HARDWARE_NAME=$(BR2_ARCH) DESTDIR="$(STAGING_DIR)" INSTALLDIR=$(STAGING_DIR) STRIP="$(TARGET_STRIP)" \
		BERKELEYDB_DIR="$(BERKELEYDB_DIR)" INSTALLFLAGS=-m755 install
endef

define BERKELEYDB_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)/$(BERKELEYDB_SUBDIR) \
		HARDWARE_NAME=$(BR2_ARCH) DESTDIR="$(TARGET_DIR)" INSTALLDIR=$(TARGET_DIR) STRIP="$(TARGET_STRIP)" \
		BERKELEYDB_DIR="$(BERKELEYDB_DIR)" INSTALLFLAGS=-m755 install
endef

ifneq ($(BR2_PACKAGE_BERKELEYDB_TOOLS),y)

define BERKELEYDB_REMOVE_TOOLS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(BERKELEYDB_BINARIES))
endef

BERKELEYDB_POST_INSTALL_TARGET_HOOKS += BERKELEYDB_REMOVE_TOOLS

endif

define BERKELEYDB_REMOVE_DOCS
	rm -rf $(TARGET_DIR)/usr/docs
endef

BERKELEYDB_POST_INSTALL_TARGET_HOOKS += BERKELEYDB_REMOVE_DOCS

$(eval $(generic-package))
