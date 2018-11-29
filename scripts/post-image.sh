#!/bin/bash

IMG_DIR=images
TMP_DIR=tmp.$$

MERL_CONF=$BR2_TOPDIR/vendor/asus/base/version.conf

BASE_VERSION=$(ls -d $BR2_OUTDIR/build/src-base-V* | grep -o -P 'base-.*' | sed -n 's,base-V\(.*\),\1,p')
if [ -e "$MERL_CONF" ] ; then
  MERLIN_VERSION=$(grep -o -P 'SERIALNO=.*' $MERL_CONF | sed -n 's,SERIALNO=\(.*\),\1,p')
fi

if [ -z "$MERLIN_VERSION" ] ; then
  VERSION="$BASE_VERSION"
else
  VERSION="${BASE_VERSION}_${MERLIN_VERSION}"
fi

cd $BR2_OUTDIR/$IMG_DIR && (

  #-- build trx file
  trx -o linux.trx vmlinuz rootfs.squashfs

  #-- build chk file
  mkdir -p $TMP_DIR && ( \
    cd $TMP_DIR && \
    touch rootfs && \
    packet -k ../linux.trx -f rootfs \
      -b $BR2_TOPDIR/vendor/netgear/router/arm-uclibc/compatible_$(echo "$PROFILE" | tr A-Z a-z).txt \
      -ok kernel_image -oall ../${PROFILE}-${VERSION}_$(date +%m%d-%H%M) -or rootfs_image \
      -i $BR2_TOPDIR/$ACOS/include/ambitCfg.h && \
    rm -rf rootfs
  )

  rm -rf $TMP_DIR
)
