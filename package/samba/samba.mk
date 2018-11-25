################################################################################
#
# samba
#
################################################################################

SAMBA_SITE = http://ftp.samba.org/pub/samba/stable
SAMBA_VERSION_FILE = source/include/version.h
SAMBA_SUBDIR = source
SAMBA_AUTOGEN = YES

SAMBA_INSTALL_STAGING = YES
SAMBA_LICENSE = GPLv3+
SAMBA_LICENSE_FILES = COPYING
# Forcibly use one job to avoid dependency issues (include/proto.h)
SAMBA_MAKE = $(MAKE1)

SAMBA_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_SAMBA_RPCCLIENT),readline) \
	$(if $(BR2_PACKAGE_SAMBA_SMBCLIENT),readline) \
	$(if $(BR2_PACKAGE_SAMBA_AVAHI),avahi) \
	$(if $(BR2_PACKAGE_SAMBA_GAMIN),gamin)

SAMBA_CONF_ENV = \
	ac_cv_file__proc_sys_kernel_core_pattern=yes \
	samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
	samba_cv_USE_SETREUID=yes \
	samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
	libreplace_cv_HAVE_IFACE_GETIFADDRS=yes \
	libreplace_cv_HAVE_IFACE_IFCONF=yes \
	libreplace_cv_HAVE_MMAP=yes \
	samba_cv_HAVE_FCNTL_LOCK=yes \
	samba_cv_fpie=no \
	libreplace_cv_HAVE_IPV6=yes \
	SMB_BUILD_CC_NEGATIVE_ENUM_VALUES=yes \
	libreplace_cv_READDIR_GETDIRENTRIES=no \
	libreplace_cv_READDIR_GETDENTS=no \
	linux_getgrouplist_ok=no \
	samba_cv_REPLACE_READDIR=no \
	samba_cv_HAVE_WRFILE_KEYTAB=yes \
	samba_cv_HAVE_IFACE_IFCONF=yes \
	$(if $(BR2_PACKAGE_SAMBA_AVAHI),AVAHI_LIBS=-pthread)

SAMBA_CONF_OPTS = \
	--with-lockdir=/var/cache/samba \
	--with-piddir=/var/run \
	--with-privatedir=/etc/samba \
	--with-logfilebase=/var/log/samba \
	--with-configdir=/etc/samba \
	\
	--disable-cups \
	--enable-shared \
	--disable-static \
	--disable-pie \
	--disable-fam \
	--disable-relro \
	--disable-dnssd \
	--disable-iprint \
	\
	$(if $(BR2_PACKAGE_SAMBA_AVAHI),--enable-avahi,--disable-avahi) \
	$(if $(BR2_PACKAGE_SAMBA_GAMIN),--enable-fam,--disable-fam) \
	$(if $(BR2_PACKAGE_SAMBA_SWAT),--enable-swat,--disable-swat) \
	\
	--without-ldap \
	--without-libaddns \
	--with-included-popt \
	--with-included-iniparser \
	--disable-cups \
	--disable-static \
	\
	$(if $(BR2_PACKAGE_SAMBA_RPCCLIENT),--with-readline=$(STAGING_DIR)) \
	$(if $(BR2_PACKAGE_SAMBA_SMBCLIENT),--with-readline=$(STAGING_DIR)) \
	$(if $(BR2_PACKAGE_SAMBA_WINBINDD),--with-winbind,--without-winbind)

SAMBA_INSTALL_TARGET_OPTS = \
	DESTDIR=$(TARGET_DIR) -C $(SAMBA_DIR)/$(SAMBA_SUBDIR) \
	installservers installbin installcifsmount \
	$(if $(BR2_PACKAGE_SAMBA_SWAT),installswat)

# binaries to keep
SAMBA_BINTARGETS_y = \
	usr/sbin/smbd \
	usr/lib/libtalloc.so \
	usr/lib/libtdb.so

# binaries to remove
SAMBA_BINTARGETS_ = \
	usr/lib/libnetapi.so* \
	usr/lib/libsmbsharemodes.so*

define SAMBA_UPDATE_DEPENDENCIES
    $(SED) 's,AC_LIBREPLACE_CC_CHECKS,,g' $(@D)/$(SAMBA_SUBDIR)/configure.in
	$(SED) '/LIBREPLACE_C99_STRUCT_INIT/d' $(@D)/$(SAMBA_SUBDIR)/configure.in
endef
SAMBA_PRE_CONFIGURE_HOOKS += SAMBA_UPDATE_DEPENDENCIES


# binaries to keep or remove
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_EVENTLOGADM) += usr/bin/eventlogadm
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NET) += usr/bin/net
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NMBD) += usr/sbin/nmbd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NMBLOOKUP) += usr/bin/nmblookup
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_NTLM_AUTH) += usr/bin/ntlm_auth
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_PDBEDIT) += usr/bin/pdbedit
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_PROFILES) += usr/bin/profiles
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_RPCCLIENT) += usr/bin/rpcclient
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCACLS) += usr/bin/smbcacls
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCLIENT) += usr/bin/smbclient
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCONTROL) += usr/bin/smbcontrol
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBCQUOTAS) += usr/bin/smbcquotas
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBD) += usr/sbin/smbd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBGET) += usr/bin/smbget
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbadd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbdel
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbedit
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbmodify
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbrename
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBLDBTOOLS) += usr/bin/ldbsearch
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBPASSWD) += usr/bin/smbpasswd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBSHARESEC) += usr/bin/sharesec
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBSPOOL) += usr/bin/smbspool
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBSTATUS) += usr/bin/smbstatus
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBTA_UTIL) += usr/bin/smbta-util
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SMBTREE) += usr/bin/smbtree
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_SWAT) += usr/sbin/swat
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TDB) += usr/bin/tdbbackup
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TDB) += usr/bin/tdbdump
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TDB) += usr/bin/tdbtool
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_TESTPARM) += usr/bin/testparm
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_WINBINDD) += usr/sbin/winbindd
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_WBINFO) += usr/bin/wbinfo
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_CIFS_MOUNT) += usr/sbin/mount.cifs usr/sbin/umount.cifs

# libraries to keep or remove
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_WINBINDD) += usr/lib/libwbclient.so*
SAMBA_BINTARGETS_$(BR2_PACKAGE_SAMBA_LIBSMBCLIENT) += usr/lib/libsmbclient.so*

# non-binaries to remove
SAMBA_TXTTARGETS_ = \
	usr/include/libsmbclient.h \
	usr/include/netapi.h \
	usr/include/smb_share_modes.h \
	usr/include/talloc.h \
	usr/include/tdb.h \
	usr/include/wbclient.h

# non-binaries to keep or remove
SAMBA_TXTTARGETS_$(BR2_PACKAGE_SAMBA_FINDSMB) += usr/bin/findsmb
SAMBA_TXTTARGETS_$(BR2_PACKAGE_SAMBA_SMBTAR) += usr/bin/smbtar

define SAMBA_REMOVE_UNNEEDED_BINARIES
	rm -f $(addprefix $(TARGET_DIR)/, $(SAMBA_BINTARGETS_))
	rm -f $(addprefix $(TARGET_DIR)/, $(SAMBA_TXTTARGETS_))
endef

SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_REMOVE_UNNEEDED_BINARIES

ifeq ($(BR2_PACKAGE_SAMBA_LIBNSS_WINS),y)
define SAMBA_INSTALL_LIBNSS_WINS
	$(INSTALL) -m 0755 -D $(@D)/nsswitch/libnss_wins.so $(TARGET_DIR)/lib/libnss_wins.so.2
	ln -snf libnss_wins.so.2 $(TARGET_DIR)/lib/libnss_wins.so
endef
SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_INSTALL_LIBNSS_WINS
endif

ifeq ($(BR2_PACKAGE_SAMBA_LIBNSS_WINBIND),y)
define SAMBA_INSTALL_LIBNSS_WINBIND
	$(INSTALL) -m 0755 -D $(@D)/nsswitch/libnss_winbind.so $(TARGET_DIR)/lib/libnss_winbind.so.2
	ln -snf libnss_winbind.so.2 $(TARGET_DIR)/lib/libnss_winbind.so
endef
SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_INSTALL_LIBNSS_WINBIND
endif

define SAMBA_REMOVE_SWAT_DOCUMENTATION
	# Remove the documentation
	rm -rf $(TARGET_DIR)/usr/swat/help/manpages
	rm -rf $(TARGET_DIR)/usr/swat/help/Samba3*
	rm -rf $(TARGET_DIR)/usr/swat/using_samba/
	# Removing the welcome.html file will make swat default to
	# welcome-no-samba-doc.html
	rm -rf $(TARGET_DIR)/usr/swat/help/welcome.html
endef

# --with-libiconv="" is to avoid detecting host libiconv and build failure
ifeq ($(BR2_PACKAGE_SAMBA_LIBICONV),y)
SAMBA_DEPENDENCIES += libiconv
SAMBA_CONF_OPTS += --with-libiconv=$(STAGING_DIR)
else
SAMBA_CONF_OPTS += --with-libiconv=""
endif

# Compiled debug messages by level
SAMBA_CONF_OPTS += CFLAGS="$(TARGET_CFLAGS) -DMAX_DEBUG_LEVEL=$(BR2_PACKAGE_SAMBA_MAX_DEBUGLEVEL)"

ifeq ($(BR2_PACKAGE_SAMBA_SWAT),y)
SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_REMOVE_SWAT_DOCUMENTATION
endif

define SAMBA_INSTALL_CONFIG
	$(INSTALL) -d $(TARGET_DIR)/usr/local/samba/lib
	$(INSTALL) -m 0644 $(@D)/data/group $(TARGET_DIR)/etc
	$(INSTALL) -m 0644 $(@D)/data/lmhosts $(TARGET_DIR)/usr/local/samba/lib
	ln -sf ../../../tmp/smaba/private $(TARGET_DIR)/usr/local/samba/private
	ln -sf ../../../var $(TARGET_DIR)/usr/local/samba/var
	ln -sf ../../../var/lock $(TARGET_DIR)/usr/local/samba/lock
	ln -sf ../../../tmp/samba/private/smb.conf $(TARGET_DIR)/usr/local/samba/lib/smb.conf
	rm -f $(TARGET_DIR)/etc/passwd && ln -sf ../tmp/samba/private/passwd $(TARGET_DIR)/etc/passwd
endef

SAMBA_POST_INSTALL_TARGET_HOOKS += SAMBA_INSTALL_CONFIG

$(eval $(autotools-package))
