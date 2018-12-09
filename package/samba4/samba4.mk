################################################################################
#
# samba4
#
################################################################################

SAMBA4_SITE = https://download.samba.org/pub/samba/stable
SAMBA4_VERSION_FILE = VERSION
SAMBA4_VERSION_PATTERN = "@(SAMBA_VERSION_MAJOR).@(SAMBA_VERSION_MINOR).@(SAMBA_VERSION_RELEASE)"
SAMBA4_LICENSE = GPL-3.0+
SAMBA4_LICENSE_FILES = COPYING
SAMBA4_DEPENDENCIES = python zlib \
	$(if $(BR2_PACKAGE_LIBAIO),libaio) \
	$(if $(BR2_PACKAGE_LIBCAP),libcap) \
	$(if $(BR2_PACKAGE_READLINE),readline) \
	$(TARGET_NLS_DEPENDENCIES)
SAMBA4_CFLAGS = $(TARGET_CFLAGS)
SAMBA4_LDFLAGS = $(TARGET_LDFLAGS)
SAMBA4_CONF_ENV = \
	CFLAGS="$(SAMBA4_CFLAGS)" \
	LDFLAGS="$(SAMBA4_LDFLAGS)"

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
SAMBA4_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`
SAMBA4_LDFLAGS += `$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`
SAMBA4_DEPENDENCIES += libtirpc host-pkgconf
endif

ifeq ($(BR2_PACKAGE_ACL),y)
SAMBA4_CONF_OPTS += --with-acl-support
SAMBA4_DEPENDENCIES += acl
else
SAMBA4_CONF_OPTS += --without-acl-support
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
SAMBA4_CONF_ENV += CUPS_CONFIG="$(STAGING_DIR)/usr/bin/cups-config"
SAMBA4_CONF_OPTS += --enable-cups
SAMBA4_DEPENDENCIES += cups
else
SAMBA4_CONF_OPTS += --disable-cups
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
SAMBA4_DEPENDENCIES += dbus
endif

ifeq ($(BR2_PACKAGE_DBUS)$(BR2_PACKAGE_AVAHI_DAEMON),yy)
SAMBA4_CONF_OPTS += --enable-avahi
SAMBA4_DEPENDENCIES += avahi
else
SAMBA4_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_GAMIN),y)
SAMBA4_CONF_OPTS += --with-fam
SAMBA4_DEPENDENCIES += gamin
else
SAMBA4_CONF_OPTS += --without-fam
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
SAMBA4_CONF_OPTS += --enable-gnutls
SAMBA4_DEPENDENCIES += gnutls
else
SAMBA4_CONF_OPTS += --disable-gnutls
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
SAMBA4_CONF_ENV += NCURSES_CONFIG="$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)"
SAMBA4_DEPENDENCIES += ncurses
else
SAMBA4_CONF_OPTS += --without-regedit
endif

ifeq ($(BR2_PACKAGE_SAMBA4_AD_DC),)
SAMBA4_CONF_OPTS += --without-ad-dc
endif

ifeq ($(BR2_PACKAGE_SAMBA4_ADS),y)
SAMBA4_CONF_OPTS += --with-ads --with-ldap --with-shared-modules=idmap_ad
SAMBA4_DEPENDENCIES += openldap
else
SAMBA4_CONF_OPTS += --without-ads --without-ldap
endif

define SAMBA4_CONFIGURE_CMDS
	$(INSTALL) -m 0644 $(BR2_EXTERNAL_NETGEAR_PATH)/package/samba4/samba4-cache.txt $(@D)/cache.txt;
	echo 'Checking uname machine type: $(BR2_ARCH)' >> $(@D)/cache.txt;
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(SAMBA4_CONF_ENV) \
		python_LDFLAGS=-L$(@D)/lib \
		python_LIBDIR=$(@D)/python_arm/lib \
		CFLAGS="-D_LARGE_FILES -D_FILE_OFFSET_BITS=64 -I$(PYTHON_DIR) -I$(PYTHON_DIR)/Include" \
		LDFLAGS="-L$(PYTHON_DIR) -L$(@D)/python_arm/lib" \
		./configure \
			--prefix=/usr/local/samba \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--with-configdir=/usr/local/samba/lib \
			--with-privatedir=/usr/local/samba/private \
			--with-lockdir=/usr/local/samba/var/locks \
			--with-piddir=/usr/local/samba/var/locks \
			--enable-fhs \
			--cross-compile \
			--cross-answers=$(@D)/cache.txt \
			--hostcc=gcc \
			--disable-rpath \
			--disable-rpath-install \
			--disable-iprint \
			--without-pam \
			--without-dmapi \
			--disable-glusterfs \
			--with-cluster-support \
			--bundled-libraries='!asn1_compile,!compile_et' \
			$(SAMBA4_CONF_OPTS) \
	)
endef

define SAMBA4_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) || ( \
		cp -f $(@D)/precompile/asn1_compile $(@D)/bin/default/source4/heimdal_build/ && \
		cp -f $(@D)/precompile/compile_et $(@D)/bin/default/source4/heimdal_build/ && \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
	)
endef

SAMBA4_LIB_LIST = \
	libaddns-samba4.so \
	libads-samba4.so \
	libasn1-samba4.so.8 \
	libasn1util-samba4.so \
	libauthkrb5-samba4.so \
	libauth-samba4.so \
	libauth-sam-reply-samba4.so \
	libCHARSET3-samba4.so \
	libcliauth-samba4.so \
	libcli-cldap-samba4.so \
	libcli-ldap-common-samba4.so \
	libcli-nbt-samba4.so \
	libcli-smb-common-samba4.so \
	libcli-spoolss-samba4.so \
	libcom_err-samba4.so.0 \
	libdbwrap-samba4.so \
	libdcerpc-binding.so.0 \
	libdcerpc-samba-samba4.so \
	libflag-mapping-samba4.so \
	libgenrand-samba4.so \
	libgensec-samba4.so \
	libgse-samba4.so \
	libgssapi-samba4.so.2 \
	libhcrypto-samba4.so.5 \
	libheimbase-samba4.so.1 \
	libhx509-samba4.so.5 \
	libinterfaces-samba4.so \
	libiov-buf-samba4.so \
	libkrb5-samba4.so.26 \
	libkrb5samba-samba4.so \
	libldb.so.1 \
	libldbsamba-samba4.so \
	liblibcli-lsa3-samba4.so \
	liblibcli-netlogon3-samba4.so \
	liblibsmb-samba4.so \
	libmessages-dgm-samba4.so \
	libmessages-util-samba4.so \
	libmsghdr-samba4.so \
	libmsrpc3-samba4.so \
	libndr.so.0 \
	libndr-krb5pac.so.0 \
	libndr-nbt.so.0 \
	libndr-samba4.so \
	libndr-samba-samba4.so \
	libndr-standard.so.0 \
	libnetapi.so.0 \
	libnpa-tstream-samba4.so \
	libpopt-samba3-samba4.so \
	libpopt-samba4.so \
	libprinting-migrate-samba4.so \
	libpthread.so.0 \
	libreplace-samba4.so \
	libroken-samba4.so.19 \
	libsamba3-util-samba4.so \
	libsamba-cluster-support-samba4.so \
	libsamba-credentials.so.0 \
	libsamba-debug-samba4.so \
	libsamba-errors.so.1 \
	libsamba-hostconfig.so.0 \
	libsamba-modules-samba4.so \
	libsamba-passdb.so.0 \
	libsamba-security-samba4.so \
	libsamba-sockets-samba4.so \
	libsamba-util.so.0 \
	libsamdb.so.0 \
	libsamdb-common-samba4.so \
	libsecrets3-samba4.so \
	libserver-id-db-samba4.so \
	libserver-role-samba4.so \
	libsmbconf.so.0 \
	libsmbd-base-samba4.so \
	libsmbd-conn-samba4.so \
	libsmbd-shim-samba4.so \
	libsmbregistry-samba4.so \
	libsmb-transport-samba4.so \
	libsocket-blocking-samba4.so \
	libsys-rw-samba4.so \
	libtalloc.so.2 \
	libtalloc-report-samba4.so \
	libtdb.so.1 \
	libtdb-wrap-samba4.so \
	libtevent.so.0 \
	libtevent-unix-util.so.0 \
	libtevent-util.so.0 \
	libtime-basic-samba4.so \
	libutil-cmdline-samba4.so \
	libutil-reg-samba4.so \
	libutil-setid-samba4.so \
	libutil-tdb-samba4.so \
	libwbclient.so.0 \
	libwinbind-client-samba4.so \
	libwind-samba4.so.0

define SAMBA4_INSTALL_TARGET_CMDS
	install -d $(TARGET_DIR)/usr/local/
	install -d $(TARGET_DIR)/usr/local/samba
	install -d $(TARGET_DIR)/usr/local/samba/lib
	install -d $(TARGET_DIR)/tmp/samba/
	install -d $(TARGET_DIR)/tmp/samba/private
	install -d $(TARGET_DIR)/etc
	install -m 755 $(@D)/data/group $(TARGET_DIR)/etc
	install -m 755 $(@D)/data/lmhosts $(TARGET_DIR)/usr/local/samba/lib
	install -m 755 $(@D)/bin/default/source3/pdbedit  $(TARGET_DIR)/usr/local/samba/
	install -m 755 $(@D)/bin/default/source3/nmbd/nmbd $(TARGET_DIR)/usr/local/samba/
	install -m 755 $(@D)/bin/default/source3/smbd/smbd $(TARGET_DIR)/usr/local/samba/
	$(TARGET_STRIP) $(TARGET_DIR)/usr/local/samba/smbd
	$(TARGET_STRIP) $(TARGET_DIR)/usr/local/samba/nmbd
	$(TARGET_STRIP) $(TARGET_DIR)/usr/local/samba/pdbedit
	for lib_name in $(SAMBA4_LIB_LIST) ; do \
		find $(@D)/bin -name $$lib_name -exec cp "{}" $(TARGET_DIR)/lib/ \; && \
		$(TARGET_STRIP) $(TARGET_DIR)/lib/$$lib_name ; \
	done;
	cd $(TARGET_DIR)/usr/local/samba && unlink private || true
	cd $(TARGET_DIR)/usr/local/samba && unlink var || true
	cd $(TARGET_DIR)/usr/local/samba && unlink lock || true
	cd $(TARGET_DIR)/usr/local/samba && ln -sf ../../../tmp/samba/private private
	cd $(TARGET_DIR)/usr/local/samba && ln -sf ../../../var var
	cd $(TARGET_DIR)/usr/local/samba && ln -sf ../../../var/lock lock
	cd $(TARGET_DIR)/usr/local/samba/lib && ln -sf ../../../tmp/samba/private/smb.conf smb.conf
	cd $(TARGET_DIR)/etc && unlink passwd || true
	cd $(TARGET_DIR)/etc && ln -sf ../tmp/samba/private/passwd passwd
endef

$(eval $(generic-package))
