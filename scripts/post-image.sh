#!/bin/bash

IMG_DIR=images
TMP_DIR=tmp.$$

MERL_CONF=$BR2_TOPDIR/vendor/asus/base/version.conf

if [ -e $MERL_CONF ] ; then
  source $MERL_CONF
fi

#BASE_VERSION=$(ls -d $BR2_OUTDIR/build/router-* | grep -o -P 'router-.*' | sed -n 's,router-\(.*\),\1,p')
if [ -e "$MERL_CONF" ] ; then
  MERLIN_VERSION=$SERIALNO
fi

#if [ -z "$MERLIN_VERSION" ] ; then
  VERSION="$MERLIN_VERSION"
#else
#  VERSION="${BASE_VERSION}_${MERLIN_VERSION}"
#fi

variant=$(echo "$PROFILE" | tr A-Z a-z)

cd $BR2_OUTDIR/$IMG_DIR && (
  PREFIX=${PROFILE}-${VERSION}_$(date +%m%d-%H%M)

  mkdir -p $TMP_DIR && (
    cd $TMP_DIR
    touch rootfs

    trx -o linux.trx ../vmlinuz ../rootfs.squashfs

    #-- build (asus) trx file
    trx_asus -i linux.trx -r $BUILD_NAME,$KERNEL_VER.$FS_VER,$SERIALNO,$EXTENDNO,$PREFIX.trx && \
      mv $PREFIX.trx ..

    #-- build chk file
    packet -k linux.trx -f rootfs \
      -b $BR2_TOPDIR/vendor/intelli4u/buildroot/board/$variant/compatible_$variant.txt \
      -ok kernel_image -oall ../$PREFIX -or rootfs_image \
      -i $BR2_TOPDIR/vendor/intelli4u/buildroot/board/$variant/ambitCfg.h

    rm -rf rootfs
  )

  rm -rf $TMP_DIR
)

