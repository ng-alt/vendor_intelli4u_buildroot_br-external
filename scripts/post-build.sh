#!/bin/bash

TARGET_DIR=${BR2_OUTDIR}/target

STRIPCMD="`ls $BR2_OUTDIR/host/bin/*-strip` --remove-section=.comment --remove-section=.note --strip-debug"

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
}

function clean_files {
  #- alsa-lib
  remove /usr/bin/aserver

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
  remove_force /etc/ssl /usr/bin/openssl

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

  #- zebra
  remove /etc/ripd.conf.sample /etc/zebra.conf.sample

  #------------------------------------------------------------------
  #- remove specified directories
  remove_force /usr/include /usr/aclocal /usr/doc /share/info /usr/share/terminfo

  #- clean up man pages
  remove_with_find_force -type d -name 'man'

  #- clean up .h
  remove_with_find -type f -name '*.h'

  #- clean up .a and .la
  remove_with_find -type f \( -name '*.a' -o -name '*.la' \)

  #- clean up kernel modules.*
  remove_with_find -type f -name 'modules.*'

  #- clean up .msg, .pc and .m4
  remove_with_find -type f \( -name '*.msg' -o -name '*.m4' -o -name '*.pc' \)

  #- clean up the vacuum directories
  for name in /etc /opt /usr /share ; do
    remove_empty_dir_with_find $name
  done
}

#- MAIN
strip_exec
clean_files

exit 0

