echo "Copy Image to Ram"
echo "Copy" > /dev/vfd
cd /rootfs
cp *.tar.gz /install
echo "done"
echo "Save" > /dev/vfd
if [ -e /rootfs/etc/enigma2 ]; then
	echo "Sichere Settings"
	echo "Save" > /dev/vfd
	cd /rootfs/etc/enigma2
	rm settings
	tar -czvf /install/backup/E2Settings.tar.gz ./ > /dev/null 2>&1
	cd /
else
	echo "keine Settings gefunden"
	echo "checke SDA2"
	cd /
	umount /dev/sda1
	mount /dev/sda2 /rootfs
	if [ -e /rootfs/etc/enigma2 ]; then
		echo "Sichere Settings"
		cd /rootfs/etc/enigma2
		rm settings
		tar -czvf /install/backup/E2Settings.tar.gz ./ > /dev/null 2>&1
		cd /
		umount /dev/sda2
		mount /dev/sda1 /rootfs
	else
		echo "Keine Settings auf SDA2 gefunden"
		cd /
		umount /dev/sda2
		mount /dev/sda1 /rootfs
	fi
fi
if [ -e /rootfs/var/keys ]; then
	cd /rootfs/var/keys
	tar -czvf /install/backup/keys.tar.gz ./ > /dev/null 2>&1
	echo "done"
	cd /
else
	echo "keine keys gefunden"
	echo "checke SDA2"
	cd /
	umount /dev/sda1
	mount /dev/sda2 /rootfs
	if [ -e /rootfs/var/keys ]; then
		cd /rootfs/var/keys
		tar -czvf /install/backup/keys.tar.gz ./ > /dev/null 2>&1
		echo "done"
		cd /
		umount /dev/sda2
		mount /dev/sda1 /rootfs
	else
		echo "Keine Settings auf SDA2 gefunden"
		cd /
		umount /dev/sda2
		mount /dev/sda1 /rootfs
	fi
fi
echo "Sichere Uboot"
cd /rootfs/boot
cp uImage.gz /install
echo "umount /dev/sda1"
cd /
# Checkt im install file ob FDisk durchgeführtwerden soll oder nicht
# Für User mit Image auf der HDD kann so die Film Partition erhallten bleiben
FORMAT=`cat /rootfs/install`
[ "$FORMAT" = "format" ]; then
	umount /dev/sda1
	echo "done"
	echo "FDISK" > /dev/vfd
	echo "Partitioniere Datenträger"
	HDD=/dev/sda
	ROOTFS=$HDD"1"
	SYSFS=$HDD"2"
	SWAPFS=$HDD"3"
	DATAFS=$HDD"4"
	dd if=/dev/zero of=$HDD bs=512 count=64
	sfdisk --re-read $HDD
# Löscht die Festplatte/Stick und erstellt 4 Partitionen
#  1: 256MB Linux Uboot ext2
#  2:   1GB Linux System ext4
#  3: 128MB Swap > 128 MB sind mehr wie ausreichend ...
#  4: rest freier Speicher LINUX ext4 (bei HDD record)
	sfdisk $HDD -uM << EOF
	,256,L
	,1024,L
	,128,S
	,,L
	;
EOF
	echo "done"
	echo "Format ALL" > /dev/vfd
	echo "Formatiere Partitionen"
	echo "Format Uboot"
	mkfs.ext2 -I128 -b4096 -L BOOTFS $HDD"1"
	echo "Format System"
	mkfs.ext4 -L ROOTFS $HDD"2"
	echo "Formatiere Swap"
	mkswap $SWAPFS
	echo "Formatiere Rest Free Space"
	mkfs.ext4 -L RECORD $HDD"4"
	echo "done"
else
	umount /dev/sda1
	echo "done"
	echo "Format" > /dev/vfd
	echo "Formatiere Partitionen"
	echo "Format Uboot"
	mkfs.ext2 -I128 -b4096 -L BOOTFS $HDD"1"
	echo "Format System"
	mkfs.ext4 -L ROOTFS $HDD"2"
	echo "Formatiere Swap"
	mkswap $SWAPFS
	echo "done"
fi # END INSTALL FORMAT CHECK
echo "mounte /dev/sda2"
mount /dev/sda2 /rootfs
echo "Install" > /dev/vfd
echo "Kopiere RootFS Image auf /dev/sda2..."
cp /install/*.tar.gz /rootfs
cd /rootfs
echo "Lösche Image aus RAM ..."
rm /install/*.tar.gz
echo "Installiere RootFS ..."
tar -xf *.tar.gz
echo "Lösche RootFS Image File"
rm /rootfs/*.tar.gz
echo "done"
echo "Restore Settings"
if [ -e /install/backup/E2Settings.tar.gz ]; then
	cp /install/backup/E2Settings.tar.gz /rootfs/etc/enigma2
	cd /rootfs/etc/enigma2
	tar -xf E2Settings.tar.gz
	cd ../../..
else
	echo "keine Settings gesichert/restored"
fi
if [ -e /install/backup/keys.tar.gz ]; then
	cp /install/backup/keys.tar.gz /rootfs/var/keys
	cd /rootfs/var/keys
	tar -xf keys.tar.gz
	cd ../../..
else
	echo "keine Keys gesichert/restored"
fi
cd /
echo "umount /dev/sda2 and mount /dev/sda1"
umount /dev/sda2
sleep 1
mount /dev/sda1 /rootfs
echo "uImage" > /dev/vfd
echo "Restore Uboot"
mkdir /rootfs/boot
cp /install/uImage.gz /rootfs/boot
rm /install/uImage.gz
cd /rootfs/boot
ln -s uImage.gz uImage
cd ../..
sleep 2
umount /dev/sda1
sleep 1
echo "FSCK" > /dev/vfd
echo "Starte FSCK"
fsck.ext2 -f -y /dev/sda1
sleep 1
fsck.ext4 -f -y /dev/sda2
sleep 1
fsck.ext4 -f -y /dev/sda4
echo "done"
echo "######################################################"
echo ""
echo "  System erfolgreich Installiert, im anschluss wird   "
echo "             das System gebootet !!!                  "
echo "              na dann auf gehts ...                   "
echo ""
echo "######################################################"
sleep 1
mount /dev/sda1 /rootfs
echo "DONE..." > /dev/vfd
echo "Starte Bootvorgang ..."
