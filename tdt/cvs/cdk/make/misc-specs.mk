#Trick: ich haue mal das kopieren von /boot mal hier rein. ist fuer m82 und m84
$(DEPDIR)/boot-elf:
	$(INSTALL_DIR) $(targetprefix)/boot
	for elf in video_7109.elf video_7100.elf video_7111.elf video_7105.elf audio.elf audio_7111.elf audio_7105.elf \
	;do \
		if [ -e $(buildprefix)/root/boot/$$elf ] ; then \
			cp $(buildprefix)/root/boot/$$elf $(targetprefix)/boot/ ; \
		else \
			touch $(targetprefix)/boot/$$elf; \
		fi; \
	done
	$(INSTALL_DIR) $(targetprefix)/lib/firmware
	cp $(buildprefix)/root/firmware/*.fw $(targetprefix)/lib/firmware/
	@[ "x$*" = "x" ] && touch $@ || true

if ENABLE_ADB_BOX
LIRCD_CONF := lircd_adb_box.conf
else !ENABLE_ADB_BOX
if ENABLE_SPARK
LIRCD_CONF := lircd_spark.conf
else !ENABLE_SPARK
if ENABLE_SPARK7162
LIRCD_CONF := lircd_spark7162.conf
else !ENABLE_SPARK7162
if ENABLE_HL101
LIRCD_CONF := lircd_hl101.conf
else !ENABLE_HL101
if ENABLE_VIP1_V2
LIRCD_CONF := lircd_vip1_v2.conf
else !ENABLE_VIP1_V2
if ENABLE_VIP2_V1
LIRCD_CONF := lircd_vip2_v1.conf
else !ENABLE_VIP2_V1
if ENABLE_HOMECAST5101
LIRCD_CONF := lircd_hs5101.conf
else !ENABLE_HOMECAST5101
LIRCD_CONF := lircd.conf
endif !ENABLE_HOMECAST5101
endif !ENABLE_VIP2_V1
endif !ENABLE_VIP1_V2
endif !ENABLE_HL101
endif !ENABLE_SPARK7162
endif !ENABLE_SPARK
endif !ENABLE_ADB_BOX

$(DEPDIR)/misc-cp:
	cp $(buildprefix)/root/sbin/hotplug $(targetprefix)/sbin
	cp $(buildprefix)/root/etc/$(LIRCD_CONF) $(targetprefix)/etc/lircd.conf
	cp -rd $(buildprefix)/root/etc/hotplug $(targetprefix)/etc
	cp -rd $(buildprefix)/root/etc/hotplug.d $(targetprefix)/etc
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/firstboot:
	$(INSTALL_DIR) $(targetprefix)/var/etc
	cp -rd $(buildprefix)/root/var/etc/.firstboot $(targetprefix)/var/etc/
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/remote:
	cp $(buildprefix)/root/etc/$(LIRCD_CONF) $(targetprefix)/etc/lircd.conf
	@[ "x$*" = "x" ] && touch $@ || true

$(DEPDIR)/misc-e2:
	$(INSTALL_DIR) $(targetprefix)/media/hdd
	$(INSTALL_DIR) $(targetprefix)/media/dvd
	$(INSTALL_DIR) $(targetprefix)/hdd
	$(INSTALL_DIR) $(targetprefix)/hdd/music
	$(INSTALL_DIR) $(targetprefix)/hdd/picture
	$(INSTALL_DIR) $(targetprefix)/hdd/movie
	@[ "x$*" = "x" ] && touch $@ || true

#
# SPLASHUTILS
#
SPLASHUTILS := splashutils
SPLASHUTILS_VERSION := 1.5.4.3-7
SPLASHUTILS_SPEC := stm-target-$(SPLASHUTILS).spec
SPLASHUTILS_SPEC_PATCH :=
SPLASHUTILS_PATCHES :=

SPLASHUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).sh4.rpm

$(SPLASHUTILS_RPM): \
		$(if $(SPLASHUTILS_SPEC_PATCH),Patches/$(SPLASHUTILS_SPEC_PATCH)) \
		$(if $(SPLASHUTILS_PATCHES),$(SPLASHUTILS_PATCHES:%=Patches/%)) \
		libjpeg libmng libfreetype libpng \
		$(archivedir)/$(STLINUX)-target-$(SPLASHUTILS)-$(SPLASHUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(SPLASHUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(SPLASHUTILS_SPEC) < $(buildprefix)/Patches/$(SPLASHUTILS_SPEC_PATCH) ) &&) \
	$(if $(SPLASHUTILS_PATCHES),cp $(SPLASHUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(SPLASHUTILS_SPEC)

$(DEPDIR)/$(SPLASHUTILS): \
$(DEPDIR)/%$(SPLASHUTILS): $(SPLASHUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	cp root/etc/splash/luxisri.ttf $(targetprefix)/etc/splash/ && \
	cp -rd root/etc/splash/{vdr,liquid,together}_theme $(targetprefix)/etc/splash/ && \
	$(LN_SF) liquid_theme $(targetprefix)/etc/splash/default && \
	$(INSTALL_DIR) $(targetprefix)/lib/lsb && \
	cp root/lib/lsb/splash-functions $(targetprefix)/lib/lsb/ && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# STSLAVE
#
STSLAVE := stslave
STSLAVE_VERSION := 0.7-25
STSLAVE_SPEC := stm-target-$(STSLAVE).spec
STSLAVE_SPEC_PATCH :=
STSLAVE_PATCHES :=

STSLAVE_RPM := RPMS/sh4/$(STLINUX)-sh4-$(STSLAVE)-$(STSLAVE_VERSION).sh4.rpm

$(STSLAVE_RPM): \
		$(if $(STSLAVE_SPEC_PATCH),Patches/$(STSLAVE_SPEC_PATCH)) \
		$(if $(STSLAVE_PATCHES),$(STSLAVE_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(STSLAVE)-$(STSLAVE_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(STSLAVE_SPEC_PATCH),( cd SPECS && patch -p1 $(STSLAVE_SPEC) < $(buildprefix)/Patches/$(STSLAVE_SPEC_PATCH) ) &&) \
	$(if $(STSLAVE_PATCHES),cp $(STSLAVE_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(STSLAVE_SPEC)

$(DEPDIR)/$(STSLAVE): \
$(DEPDIR)/%$(STSLAVE): linux-kernel-headers binutils-dev $(STSLAVE_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# OPENSSL
#
OPENSSL := openssl
OPENSSL_DEV := openssl-dev
OPENSSL_VERSION := 0.9.8l-16
OPENSSL_SPEC := stm-target-$(OPENSSL).spec
if NEWOS
OPENSSL_SPEC_PATCH := stm-target-$(OPENSSL).$(OPENSSL_VERSION)-newos.diff
OPENSSL_PATCHES :=
else
OPENSSL_SPEC_PATCH :=
OPENSSL_PATCHES :=
endif

OPENSSL_RPM := RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL)-$(OPENSSL_VERSION).sh4.rpm
OPENSSL_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(OPENSSL_DEV)-$(OPENSSL_VERSION).sh4.rpm

$(OPENSSL_RPM) $(OPENSSL_DEV_RPM): \
		$(if $(OPENSSL_SPEC_PATCH),Patches/$(OPENSSL_SPEC_PATCH)) \
		$(if $(OPENSSL_PATCHES),$(OPENSSL_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(OPENSSL)-$(OPENSSL_VERSION).src.rpm
	@echo "----------------------------------------------------------------"
	@echo "| If Script can't locate find.pl                               |"
	@echo "| Copy    own_build/perl/find.pl    to     /usr/lib/perl...    |"
	@echo "| Because in newer Versions there is no find.pl                |"
	@echo "----------------------------------------------------------------"
#	sudo cp $(buildprefix)/own_build/perl/find.pl /usr/lib/perl*/site_perl/*/*/
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(OPENSSL_SPEC_PATCH),( cd SPECS && patch -p1 $(OPENSSL_SPEC) < $(buildprefix)/Patches/$(OPENSSL_SPEC_PATCH) ) &&) \
	$(if $(OPENSSL_PATCHES),cp $(OPENSSL_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(OPENSSL_SPEC)

$(DEPDIR)/$(OPENSSL): \
$(DEPDIR)/%$(OPENSSL): $(OPENSSL_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	sed -i "s,^prefix=.*,prefix=$(targetprefix)/usr," $(targetprefix)/usr/lib/pkgconfig/libcrypto.pc
	sed -i "s,^prefix=.*,prefix=$(targetprefix)/usr," $(targetprefix)/usr/lib/pkgconfig/libssl.pc
	sed -i "s,^prefix=.*,prefix=$(targetprefix)/usr," $(targetprefix)/usr/lib/pkgconfig/openssl.pc
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/$(OPENSSL_DEV): \
$(DEPDIR)/%$(OPENSSL_DEV): %$(OPENSSL) $(OPENSSL_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# ALSALIB
#
ALSALIB := alsa-lib
ALSALIB_DEV := alsa-lib-dev
ALSALIB_VERSION := 1.0.21a-23
ALSALIB_SPEC := stm-target-$(ALSALIB).spec
ALSALIB_SPEC_PATCH :=
ALSALIB_PATCHES :=

ALSALIB_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB)-$(ALSALIB_VERSION).sh4.rpm
ALSALIB_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSALIB_DEV)-$(ALSALIB_VERSION).sh4.rpm

$(ALSALIB_RPM) $(ALSALIB_DEV_RPM): \
		$(if $(ALSALIB_SPEC_PATCH),Patches/$(ALSALIB_SPEC_PATCH)) \
		$(if $(ALSALIB_PATCHES),$(ALSALIB_PATCHES:%=Patches/%)) \
		$(archivedir)/$(STLINUX)-target-$(ALSALIB)-$(ALSALIB_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSALIB_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSALIB_SPEC) < $(buildprefix)/Patches/$(ALSALIB_SPEC_PATCH) ) &&) \
	$(if $(ALSALIB_PATCHES),cp $(ALSALIB_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(ALSALIB_SPEC)

$(DEPDIR)/$(ALSALIB): \
$(DEPDIR)/%$(ALSALIB): $(ALSALIB_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/$(ALSALIB_DEV): \
$(DEPDIR)/%$(ALSALIB_DEV): %$(ALSALIB) $(ALSALIB_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# ALSAUTILS
#
ALSAUTILS := alsa-utils
ALSAUTILS_VERSION := 1.0.16-16
ALSAUTILS_SPEC := stm-target-$(ALSAUTILS).spec
ALSAUTILS_SPEC_PATCH :=
ALSAUTILS_PATCHES :=

ALSAUTILS_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAUTILS)-$(ALSAUTILS_VERSION).sh4.rpm

$(ALSAUTILS_RPM): \
		$(if $(ALSAUTILS_SPEC_PATCH),Patches/$(ALSAUTILS_SPEC_PATCH)) \
		$(if $(ALSAUTILS_PATCHES),$(ALSAUTILS_PATCHES:%=Patches/%)) \
		$(NCURSES_DEV) $(ALSALIB_DEV) \
		$(archivedir)/$(STLINUX)-target-$(ALSAUTILS)-$(ALSAUTILS_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSAUTILS_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSAUTILS_SPEC) < $(buildprefix)/Patches/$(ALSAUTILS_SPEC_PATCH) ) &&) \
	$(if $(ALSAUTILS_PATCHES),cp $(ALSAUTILS_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --nodeps --target=sh4-linux SPECS/$(ALSAUTILS_SPEC)

$(DEPDIR)/$(ALSAUTILS): \
$(DEPDIR)/%$(ALSAUTILS): $(ALSAUTILS_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

#
# ALSAPLAYER
#
ALSAPLAYER := alsaplayer
ALSAPLAYER_DEV := alsaplayer-dev
ALSAPLAYER_VERSION := 0.99.77-15
ALSAPLAYER_SPEC := stm-target-$(ALSAPLAYER).spec
ALSAPLAYER_SPEC_PATCH :=
ALSAPLAYER_PATCHES :=

ALSAPLAYER_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).sh4.rpm
ALSAPLAYER_DEV_RPM := RPMS/sh4/$(STLINUX)-sh4-$(ALSAPLAYER_DEV)-$(ALSAPLAYER_VERSION).sh4.rpm

$(ALSAPLAYER_RPM) $(ALSAPLAYER_DEV_RPM): \
		$(if $(ALSAPLAYER_SPEC_PATCH),Patches/$(ALSAPLAYER_SPEC_PATCH)) \
		$(if $(ALSAPLAYER_PATCHES),$(ALSAPLAYER_PATCHES:%=Patches/%)) \
		libmad libid3tag \
		$(archivedir)/$(STLINUX)-target-$(ALSAPLAYER)-$(ALSAPLAYER_VERSION).src.rpm
	rpm $(DRPM) --nosignature -Uhv $(lastword $^) && \
	$(if $(ALSAPLAYER_SPEC_PATCH),( cd SPECS && patch -p1 $(ALSAPLAYER_SPEC) < $(buildprefix)/Patches/$(ALSAPLAYER_SPEC_PATCH) ) &&) \
	$(if $(ALSAPLAYER_PATCHES),cp $(ALSAPLAYER_PATCHES:%=Patches/%) SOURCES/ &&) \
	export PATH=$(hostprefix)/bin:$(PATH) && \
	export PKG_CONFIG_PATH=$(targetprefix)/usr/include/pkgconfig && \
	rpmbuild $(DRPMBUILD) -bb -v --clean --target=sh4-linux SPECS/$(ALSAPLAYER_SPEC)

$(DEPDIR)/$(ALSAPLAYER): \
$(DEPDIR)/%$(ALSAPLAYER): $(ALSAPLAYER_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@

$(DEPDIR)/$(ALSAPLAYER_DEV): \
$(DEPDIR)/%$(ALSAPLAYER_DEV): $(ALSAPLAYER_DEV_RPM)
	@rpm --dbpath $(prefix)/$*cdkroot-rpmdb $(DRPM) --ignorearch --nodeps -Uhv \
		--badreloc --relocate $(targetprefix)=$(prefix)/$*cdkroot $(lastword $^) && \
	[ "x$*" = "x" ] && touch -r $(lastword $^) $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
