################################################################################
#
# avahi
#
################################################################################

#
# This program is free software; you can redistribute it
# and/or modify it under the terms of the GNU Lesser General
# Public License as published by the Free Software Foundation
# either version 2.1 of the License, or (at your option) any
# later version.

AVAHI_SITE = https://github.com/lathiat/avahi/releases/download/v$(AVAHI_VERSION)
AVAHI_LICENSE = LGPL-2.1+
AVAHI_LICENSE_FILES = LICENSE
AVAHI_INSTALL_STAGING = YES
AVAHI_AUTOGEN = YES

AVAHI_CONF_ENV = \
	ac_cv_func_strtod=yes \
	ac_fsusage_space=yes \
	fu_cv_sys_stat_statfs2_bsize=yes \
	ac_cv_func_closedir_void=no \
	ac_cv_func_getloadavg=no \
	ac_cv_lib_util_getloadavg=no \
	ac_cv_lib_getloadavg_getloadavg=no \
	ac_cv_func_getgroups=yes \
	ac_cv_func_getgroups_works=yes \
	ac_cv_func_chown_works=yes \
	ac_cv_have_decl_euidaccess=no \
	ac_cv_func_euidaccess=no \
	ac_cv_have_decl_strnlen=yes \
	ac_cv_func_strnlen_working=yes \
	ac_cv_func_lstat_dereferences_slashed_symlink=yes \
	ac_cv_func_lstat_empty_string_bug=no \
	ac_cv_func_stat_empty_string_bug=no \
	vb_cv_func_rename_trailing_slash_bug=no \
	ac_cv_have_decl_nanosleep=yes \
	jm_cv_func_nanosleep_works=yes \
	gl_cv_func_working_utimes=yes \
	ac_cv_func_utime_null=yes \
	ac_cv_have_decl_strerror_r=yes \
	ac_cv_func_strerror_r_char_p=no \
	jm_cv_func_svid_putenv=yes \
	ac_cv_func_getcwd_null=yes \
	ac_cv_func_getdelim=yes \
	ac_cv_func_mkstemp=yes \
	utils_cv_func_mkstemp_limitations=no \
	utils_cv_func_mkdir_trailing_slash_bug=no \
	jm_cv_func_gettimeofday_clobber=no \
	am_cv_func_working_getline=yes \
	gl_cv_func_working_readdir=yes \
	jm_ac_cv_func_link_follows_symlink=no \
	utils_cv_localtime_cache=no \
	ac_cv_struct_st_mtim_nsec=no \
	gl_cv_func_tzset_clobber=no \
	gl_cv_func_getcwd_null=yes \
	gl_cv_func_getcwd_path_max=yes \
	ac_cv_func_fnmatch_gnu=yes \
	am_getline_needs_run_time_check=no \
	am_cv_func_working_getline=yes \
	gl_cv_func_mkdir_trailing_slash_bug=no \
	gl_cv_func_mkstemp_limitations=no \
	ac_cv_func_working_mktime=yes \
	jm_cv_func_working_re_compile_pattern=yes \
	ac_use_included_regex=no \
	avahi_cv_sys_cxx_works=yes \
	DATADIRNAME=share

# Note: even if we have Gtk2 and Gtk3 support in Buildroot, we
# explicitly disable support for them, in order to avoid the following
# circular dependencies:
#
#  avahi -> libglade -> libgtk2 -> cups -> avahi
#  avahi -> libgtk3 -> cups -> avahi
#
# Since Gtk2 and Gtk3 in Avahi are only used for some example/demo
# programs, we decided to disable their support to solve the circular
# dependency.
AVAHI_CONF_OPTS = \
	--disable-dbm \
	--enable-gdbm \
	--disable-qt3 \
	--disable-qt4 \
	--disable-gtk \
	--disable-gtk3 \
	--disable-gdbm \
	--disable-pygtk \
	--disable-mono \
	--disable-monodoc \
	--disable-doxygen-dot \
	--disable-stack-protector \
	--with-distro=none \
	--disable-manpages \
	--disable-doxygen-man \
	--disable-doxygen-rtf \
	--disable-doxygen-xml \
	--disable-doxygen-chm \
	--disable-doxygen-chi \
	--disable-doxygen-html \
	--disable-doxygen-ps \
	--disable-doxygen-pdf \
	--disable-xmltoman \
	$(if $(BR2_PACKAGE_AVAHI_AUTOIPD),--enable,--disable)-autoipd \
	--with-avahi-user=root \
	--with-avahi-group=root \
	--with-autoipd-user=root \
	--with-autoipd-group=root \
	--disable-stack-protector

AVAHI_DEPENDENCIES = \
	host-intltool host-pkgconf \
	$(TARGET_NLS_DEPENDENCIES)

AVAHI_DEPENDENCIES += $(if $(BR2_PACKAGE_ROUTER),router)

AVAHI_CFLAGS = $(TARGET_CFLAGS)

ifneq ($(BR2_PACKAGE_AVAHI_DAEMON)$(BR2_PACKAGE_AVAHI_AUTOIPD),)
AVAHI_DEPENDENCIES += libdaemon
else
AVAHI_CONF_OPTS += --disable-libdaemon
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
AVAHI_DEPENDENCIES += libcap
endif

ifeq ($(BR2_PACKAGE_AVAHI_DAEMON),y)
AVAHI_DEPENDENCIES += expat
AVAHI_CONF_OPTS += --with-xml=expat
else
AVAHI_CONF_OPTS += --with-xml=none
endif

ifeq ($(BR2_PACKAGE_AVAHI_LIBDNSSD_COMPATIBILITY),y)
AVAHI_CONF_OPTS += --enable-compat-libdns_sd
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
AVAHI_DEPENDENCIES += dbus
else
AVAHI_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
AVAHI_DEPENDENCIES += libglib2
else
AVAHI_CONF_OPTS += --disable-glib --disable-gobject
endif

ifeq ($(BR2_PACKAGE_PYTHON),y)
AVAHI_CONF_ENV += \
	am_cv_pathless_PYTHON=python \
	am_cv_path_PYTHON=$(PYTHON_TARGET_BINARY) \
	am_cv_python_version=$(PYTHON_VERSION) \
	am_cv_python_platform=linux2 \
	am_cv_python_pythondir=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	am_cv_python_pyexecdir=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	py_cv_mod_socket_=yes

AVAHI_DEPENDENCIES += python
AVAHI_CONF_OPTS += --enable-python
else
AVAHI_CONF_OPTS += --disable-python --disable-pygtk --disable-python-dbus
endif

ifeq ($(BR2_PACKAGE_DBUS_PYTHON),y)
AVAHI_CONF_OPTS += --enable-python-dbus
AVAHI_CONF_ENV += py_cv_mod_dbus_=yes
AVAHI_DEPENDENCIES += dbus-python
else
AVAHI_CONF_OPTS += --disable-python-dbus
endif

# avahi-daemon refers to src-base
AVAHI_CONF_ENV += CFLAGS="$(AVAHI_CFLAGS) -I$(SRC_BASE_DIR)/include -I$(ROUTER_DIR)/shared" LDFLAGS="-L$(TARGET_DIR)/usr/lib -lnvram"

AVAHI_MAKE_OPTS += LIBS=$(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_AVAHI_AUTOIPD),y)
define AVAHI_INSTALL_AUTOIPD
	rm -f $(TARGET_DIR)/var/lib/avahi-autoipd
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/var/lib
	ln -sf /tmp/avahi-autoipd $(TARGET_DIR)/var/lib/avahi-autoipd
endef

AVAHI_POST_INSTALL_TARGET_HOOKS += AVAHI_INSTALL_AUTOIPD
endif

ifeq ($(BR2_PACKAGE_AVAHI_LIBDNSSD_COMPATIBILITY),y)
# applications expects to be able to #include <dns_sd.h>
define AVAHI_STAGING_INSTALL_LIBDNSSD_LINK
	ln -sf avahi-compat-libdns_sd/dns_sd.h \
		$(STAGING_DIR)/usr/include/dns_sd.h
endef

AVAHI_POST_INSTALL_STAGING_HOOKS += AVAHI_STAGING_INSTALL_LIBDNSSD_LINK
endif

AVAHI_BINTARGETS_$(BR2_PACKAGE_AVAHI_DNSCONFD) = dnsconfd

define AVAHI_REMOVE_UNNEEDED_BINARIES
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/, $(AVAHI_BINTARGETS_))
endef

AVAHI_POST_INSTALL_TARGET_HOOKS += AVAHI_REMOVE_UNNEEDED_BINARIES

$(eval $(autotools-package))
