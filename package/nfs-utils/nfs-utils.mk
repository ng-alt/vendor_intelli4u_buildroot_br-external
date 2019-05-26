################################################################################
#
# nfs-utils
#
################################################################################

NFS_UTILS_LICENSE = GPL-2.0+
NFS_UTILS_LICENSE_FILES = COPYING
NFS_UTILS_AUTORECONF = YES
NFS_UTILS_DEPENDENCIES = host-pkgconf

NFS_UTILS_CONF_ENV = knfsd_cv_bsd_signals=no

NFS_UTILS_CONF_OPTS = \
	--enable-shared \
	--enable-nfsv3 \
	--disable-nfsv4 \
	--disable-nfsv41 \
	--disable-gss \
	--disable-uuid \
	--disable-ipv6 \
	--disable-mount \
	--without-tcp-wrappers

NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPCDEBUG) += usr/sbin/rpcdebug
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_LOCKD) += usr/sbin/rpc.lockd
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_RQUOTAD) += usr/sbin/rpc.rquotad

ifeq ($(BR2_PACKAGE_LIBCAP),y)
NFS_UTILS_CONF_OPTS += --enable-caps
NFS_UTILS_DEPENDENCIES += libcap
else
NFS_UTILS_CONF_OPTS += --disable-caps
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
NFS_UTILS_CONF_OPTS += --enable-tirpc
NFS_UTILS_DEPENDENCIES += libtirpc
else
NFS_UTILS_CONF_OPTS += --disable-tirpc
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
NFS_UTILS_CONF_OPTS += --with-systemd=/usr/lib/systemd/system
NFS_UTILS_DEPENDENCIES += systemd
else
NFS_UTILS_CONF_OPTS += --without-systemd
endif

define NFS_UTILS_DISABLE_INSTALLATION
	$(SED) 's,SUBDIRS = tools support utils linux-nfs,SUBDIRS = support utils linux-nfs,' $(@D)/Makefile.am
endef
NFS_UTILS_PRE_CONFIGURE_HOOKS += NFS_UTILS_DISABLE_INSTALLATION

define NFS_UTILS_REMOVE_NFSIOSTAT
	rm -f $(TARGET_DIR)/usr/sbin/nfsiostat
endef

# nfsiostat is interpreted python, so remove it unless it's in the target
NFS_UTILS_POST_INSTALL_TARGET_HOOKS += $(if $(BR2_PACKAGE_PYTHON),,NFS_UTILS_REMOVE_NFSIOSTAT)

$(eval $(autotools-package))
