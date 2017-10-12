################################################################################
#
# iptables
#
################################################################################

IPTABLES_SITE = http://ftp.netfilter.org/pub/iptables
IPTABLES_AUTOGEN = YES
IPTABLES_INSTALL_STAGING = YES
IPTABLES_DEPENDENCIES = host-pkgconf linux \
	$(if $(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),libnetfilter_conntrack)
IPTABLES_LICENSE = GPL-2.0
IPTABLES_LICENSE_FILES = COPYING
# Building static causes ugly warnings on some plugins
IPTABLES_CONF_OPTS = --libexecdir=/usr/lib --with-kernel=$(LINUX_DIR)/usr

# For connlabel match
ifeq ($(BR2_PACKAGE_LIBNETFILTER_CONNTRACK),y)
IPTABLES_DEPENDENCIES += libnetfilter_conntrack
endif

# For nfnl_osf
ifeq ($(BR2_PACKAGE_LIBNFNETLINK),y)
IPTABLES_DEPENDENCIES += libnfnetlink
endif

# For iptables-compat tools
ifeq ($(BR2_PACKAGE_IPTABLES_NFTABLES),y)
IPTABLES_CONF_OPTS += --enable-nftables
IPTABLES_DEPENDENCIES += host-bison host-flex libmnl libnftnl
else
IPTABLES_CONF_OPTS += --disable-nftables
endif

ifneq ($(BR2_PACKAGE_IPTABLES_IPV4),y)
IPTABLES_CONF_OPTS += --disable-ipv4
else
IPTABLES_CONF_OPTS += --enable-ipv4
endif

ifneq ($(BR2_PACKAGE_IPTABLES_IPV6),y)
IPTABLES_CONF_OPTS += --disable-ipv6
else
IPTABLES_CONF_OPTS += --enable-ipv6
endif

# bpf compiler support and nfsynproxy tool
ifeq ($(BR2_PACKAGE_IPTABLES_BPF_NFSYNPROXY),y)
# libpcap is tricky for static-only builds and needs help
ifeq ($(BR2_STATIC_LIBS),y)
IPTABLES_LIBS_FOR_STATIC_LINK += `$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`
IPTABLES_CONF_OPTS += LIBS="$(IPTABLES_LIBS_FOR_STATIC_LINK)"
endif
IPTABLES_CONF_OPTS += --enable-bpf-compiler --enable-nfsynproxy
IPTABLES_DEPENDENCIES += libpcap
else
IPTABLES_CONF_OPTS += --disable-bpf-compiler --disable-nfsynproxy
endif

$(eval $(autotools-package))
