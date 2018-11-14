################################################################################
#
# zebra
#
################################################################################

ZEBRA_SITE = http://www.zebra.org
ZEBRA_LICENSE_FILES = COPYING COPYING.LIB

ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_NETLINK),--enable-netlink,--disable-netlink)
ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_IPV6),--enable-ipv6,--disable-ipv6)
ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_BGPD),--enable-bgpd,--disable-bgpd)
ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_RIPNGD),--enable-ripngd,--disable-ripngd)
ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_OSPFD),--enable-ospfd,--disable-ospfd)
ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_OSPF6D),--enable-ospf6d,--disable-ospf6d)
ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_BGP_ANNOUNCE),--enable-bgp-announce,--disable-bgp-announce)
ZEBRA_CONF_OPTS += $(if $(BR2_PACKAGE_ZEBRA_TCP_ZEBRA),--enable-tcp-zebra,--disable-tcp-zebra)

define ZEBRA_DISABLE_BUILD
	$(SED) 's, doc,,' $(@D)/Makefile.am
	$(SED) 's, doc,,' $(@D)/Makefile.in
endef
ZEBRA_PRE_CONFIGURE_HOOKS += ZEBRA_DISABLE_BUILD

$(eval $(autotools-package))
