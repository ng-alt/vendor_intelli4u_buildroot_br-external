#!/bin/bash

TARGET_DIR=$BR2_OUTDIR/target

STRIPCMD="arm-linux-strip --strip-unneeded"

function exists {
  if [ -e $TARGET_DIR/$1 ] ; then
    true
  else
    false
  fi
}

function size {
  ls -l $TARGET_DIR/$1 2>/dev/null | awk ' { print $5 } '
}

function strip {
  $STRIPCMD $TARGET_DIR/$1 2>/dev/null
}

function remove {
  for file in $* ; do
    if [ -e "$TARGET_DIR$file" ] ; then
      rm -v $TARGET_DIR$file 2>/dev/null
    fi
  done
}

function remove_force {
  for file in $* ; do
    rm -vrf  $TARGET_DIR$file 2>/dev/null
  done
}

function remove_dir {
  for dir in $* ; do
    if [ -e $TARGET_DIR$dir ] ; then
      rmdir -v $TARGET_DIR$dir 2>/dev/null
    fi
  done
}

function remove_with_find {
  find $TARGET_DIR $* -exec rm -v {} \;
}

function remove_with_find_force {
  find $TARGET_DIR $* -exec rm -vrf {} \;
}

function remove_empty_dir_with_find {
  find ${TARGET_DIR}$1 -type d -exec rmdir {} \; 2>/dev/null
  find ${TARGET_DIR}$1 -type d -exec rmdir {} \; 2>/dev/null
  find ${TARGET_DIR}$1 -type d -exec rmdir {} \; 2>/dev/null
  find ${TARGET_DIR}$1 -type d -exec rmdir {} \; 2>/dev/null
}

function get_link {
  ls -l $TARGET_DIR/$1 | awk ' { print $11 } '
}

#-------------------------------------------
function strip_exec {
  #- strip executables in directory /opt
  for file in opt/leafp2p/leafp2p \
              opt/rcagent/cgi/rccommand.cgi \
              opt/rcagent/cgi_processor \
              opt/rcagent/downloader \
              opt/rcagent/nas_service \
              opt/rcagent/rcagentd \
              opt/remote/remote \
              opt/remote/run_remote \
              opt/xagent/genie_handler \
              opt/xagent/xagent \
              opt/xagent/xagent_control \
              www/cgi-bin/genie.cgi; do
    if $(exists $file) ; then
      origin=$(size $file)
      $(strip $file)
      if [ $? -eq 0 ] ; then
        new=$(size $file)
        printf "Strip $file (%.2f%%) ...\n" $(echo "scale=2;$new*100/$origin" | bc)
      fi
    fi
  done

  #- strip ko files
  find $TARGET_DIR/lib/modules/ -name '*.ko' -exec $STRIPCMD {} \;
}

function clean_files {
  #- alsa-lib
  remove /usr/bin/aserver

  #- berkeleydb
  remove /usr/bin/db_sql

  #- busybox
  # remove /etc/inittab

  #- dbus
  remove /usr/bin/dbus-cleanup-sockets \
         /usr/bin/dbus-launch \
         /usr/bin/dbus-monitor \
         /usr/bin/dbus-send \
         /usr/bin/uuidgen

  #- dhcp
  remove /usr/sbin/dhcp6r

  #- e2fsprog
  remove /bin/chattr /bin/lsattr /bin/uuidgen

  #- ffmpeg
  remove /usr/bin/ffmpeg
  remove_force /usr/share/ffmpeg/examples
  remove_with_find -type f -name '*ffpreset'

  #- flac
  remove /usr/bin/flac /usr/bin/metaflac

  #- flex
  remove /usr/bin/flex

  #- gdbm
  remove /usr/bin/gdbm_dump /usr/bin/gdbm_load /usr/bin/gdbmtool

  #- geoip
  remove /usr/bin/geoiplookup /usr/bin/geoiplookup6 /usr/bin/geoipupdate

  #- gperf
  remove /usr/bin/gperf

  #- gettext
  remove /usr/bin/envsubst /usr/bin/gettext /usr/bin/gettext.sh /usr/bin/ngettext

  #- iconv
  remove /usr/bin/iconv

  #- iperf
  remove /usr/bin/iperf

  #- iptables
  remove_force /usr/lib/xtables

  #- libav
  remove /usr/bin/avconv /usr/bin/avprobe /usr/bin/avserver

  #- libgcrypt
  remove /usr/bin/dumpsexp /usr/bin/hmac256

  #- libgpg-error
  remove /usr/bin/gpg-error
  remove_force /usr/share/common-lisp/source/gpg-error

  #- libpng
  remove /usr/bin/libpng-config /usr/bin/libpng12-config

  #- libxml2
  remove /usr/bin/xmlcatalog /usr/bin/xmllint

  #- libstdc++
  remove_with_find -type f -name 'libstdc++.so*-gdb.py'

  #- lighttpd
  remove /usr/sbin/lighttd-angel

  #- openssl
  remove_force /etc/ssl

  #- pcre
  remove /usr/bin/pcregrep /usr/bin/pcretest

  #- radvd
  remove /usr/sbin/radvdump

  #- router
  remove_force /rom/cfe

  #- sqlite
  remove /usr/bin/sqlite3

  #- transmission
  remove /usr/bin/transmission-create /usr/bin/transmission-edit /usr/bin/transmission-show

  #- tre
  remove /usr/bin/agrep

  #- udev
  remove /usr/bin/udevinfo /usr/bin/udevtest /sbin/udev /sbin/udevsettle /sbin/udevcontrol \
         /usr/sbin/udevmonitor

  #- usb-modeswitch
  remove /usr/sbin/usb_modeswitch_dispatcher

  #- wx
  remove_force /usr/lib/wx /usr/share/bakefile/presets

  #------------------------------------------------------------------
  #- remove lib32 by skeleton-custom
  remove /lib32 /usr/lib32

  #- remove specified directories
  remove_force /usr/include /usr/aclocal /usr/doc /share/info /usr/share/terminfo

  #- clean up man pages
  remove_with_find_force -type d -name 'man'

  #- clean up .h
  remove_with_find -type f -name '*.h'

  #- clean up .a and .la
  remove_with_find -type f \( -name '*.a' -o -name '*.la' \)

  #- clean up kernel modules.*
  remove_with_find -type f \( \( -name 'modules*' \) -a \
    -not \( -name modules.dep -o -name modules.builtin -o -name modules.order \) \)

  #- clean up .msg, .pc and .m4
  remove_with_find -type f \( -name '*.msg' -o -name '*.m4' -o -name '*.pc' \)

  #- clean up the vacuum directories
  for name in /etc /opt /usr /share ; do
    remove_empty_dir_with_find $name
  done
}

function update_kobjs {
  # follow asus-merlin router/Makefile to shorten ko paths
  mv -f $TARGET_DIR/lib/modules/*/kernel/drivers/net/{bcm57xx,ctf,ctf_5358,et,et.4702,emf,igs,wl}/*.ko $TARGET_DIR/lib/modules/*/kernel/drivers/net/ 2>/dev/null
  mv -f $TARGET_DIR/lib/modules/*/kernel/drivers/net/wl/{wl_high,wl_sta}/wl_high.ko $TARGET_DIR/lib/modules/*/kernel/drivers/net/ 2>/dev/null
  mv -f $TARGET_DIR/lib/modules/*/kernel/drivers/usb/{hcd,host,storage,serial,core,class,misc}/*.ko $TARGET_DIR/lib/modules/*/kernel/drivers/usb/ 2>/dev/null

  mv -f $TARGET_DIR/lib/modules/*/kernel/fs/{cifs,exportfs,ext2,ext3,ext4,fat,fuse,hfsplus,jbd,jbd2,jffs,jffs2,lockd,msdos,nfs,nfsd,nls,ntfs,smbfs,reiserfs,vfat,xfs}/*.ko $TARGET_DIR/lib/modules/*/kernel/fs/ 2>/dev/null
  mv -f $TARGET_DIR/lib/modules/*/kernel/lib/{zlib_inflate,zlib_deflate,lzo}/*.ko $TARGET_DIR/lib/modules/*/kernel/lib 2>/dev/null
  mv -f $TARGET_DIR/lib/modules/*/kernel/net/{sunrpc,sunrpc/auth_gss}/*.ko $TARGET_DIR/lib/modules/*/kernel/net/ 2>/dev/null

  # execute to remove dirs twice (two-level directory movement)
  find $TARGET_DIR/lib/modules/*/kernel/ -type d -exec rmdir {} \; 2>/dev/null
  find $TARGET_DIR/lib/modules/*/kernel/ -type d -exec rmdir {} \; 2>/dev/null

  $BR2_TOPDIR/external/busybox/examples/depmod.pl -k $BR2_OUTDIR/build/linux*/vmlinux -b $TARGET_DIR/lib/modules/*/
}

#- MAIN
update_kobjs

strip_exec
clean_files

exit 0

