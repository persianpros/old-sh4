#!/bin/bash

CURDIR=$1
RELEASEDIR=$2

TMPROOTDIR=$3
TMPKERNELDIR=$4
TMPFWDIR=$5

cp -a $RELEASEDIR/* $TMPROOTDIR
cp $RELEASEDIR/.version $TMPROOTDIR

cd $TMPROOTDIR/dev/
if [ -e $TMPROOTDIR/var/etc/init.d/makedev ]; then
	$TMPROOTDIR/var/etc/init.d/makedev start
else
	$TMPROOTDIR/etc/init.d/makedev start
fi
cd -

mv $TMPROOTDIR/boot/uImage $TMPKERNELDIR/uImage

mv $TMPROOTDIR/boot/audio.elf $TMPFWDIR/audio.elf
mv $TMPROOTDIR/boot/video.elf $TMPFWDIR/video.elf

rm -f $TMPROOTDIR/boot/*

if [ -e $TMPROOTDIR/var/etc/fstab ]; then
	echo "/dev/mtdblock3	/boot	jffs2	defaults	0	0" >> $TMPROOTDIR/var/etc/fstab
	#echo "/dev/mtdblock5	/swap	jffs2	defaults	0	0" >> $TMPROOTDIR/var/etc/fstab
else
	echo "/dev/mtdblock3	/boot	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab
	#echo "/dev/mtdblock5	/swap	jffs2	defaults	0	0" >> $TMPROOTDIR/etc/fstab
fi
