# Broadcom ARM platform
export RT-AC68U_BASE := IPV6SUPP=y HTTPS=y ARM=y BCM57=y AUTODICT=y BBEXTRAS=y USBEXTRAS=y EBTABLES=y \
                        SAMBA3=3.6.x MEDIASRV=y MODEM=n MODEMPIN=n BECEEM=y PARENTAL2=y ACCEL_PPTPD=y PRINTER=y STAINFO=y \
                        WEBDAV=y USB="USB" GRO=y APP="network" PROXYSTA=y JFFS2USERICON=y \
                        CLOUDSYNC=y SWEBDAVCLIENT=y DROPBOXCLIENT=y FTPCLIENT=y SAMBACLIENT=y \
                        DNSMQ=y SHP=y NVRAM_64K=y RTAC68U=y BCMWL6=y BCMWL6A=y TUNEK="n" BCM5301X=y DISK_MONITOR=y \
                        BTN_WIFITOG=y LOGO_LED=y OPTIMIZE_XBOX=y ODMPID=y ROG=y SSD=n EMAIL=y \
                        BCMSMP=y XHCI=y SSH=y JFFS2=y NFS=y OPENVPN=y USER_LOW_RSSI=y \
                        TIMEMACHINE=y MDNS=y VPNC=y BRCM_NAND_JFFS2=y JFFS2LOG=y BCMFA=y BWDPI=y HSPOT=y \
                        DUMP_OOPS_MSG=y LINUX_MTD="64" BCM7=n TEMPROOTFS=y DEBUGFS=y SNMPD=y TOR=y \
                        MULTICASTIPTV=y QUAGGA=y BCM_RECVFILE=n LAN50=y ATCOVER=y GETREALIP=y \
                        BCM5301X_TRAFFIC_MONITOR=n CLOUDCHECK=y NATNL=y REBOOT_SCHEDULE=y \
                        TFAT=y IPSECMOD=n REPEATER=y DUALWAN=y DNSFILTER=y UPNPIGD2=n \
                        DNSSEC=y NANO=y

export RT-AC68U := $(RT-AC68U_BASE) FAKEHDR=y FORCE_SN=380 FORCE_EN=1031
export RT-AC68U += BUILD_NAME="RT-AC68U"
