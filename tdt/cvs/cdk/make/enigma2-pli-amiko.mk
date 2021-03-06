#
# tuxbox/enigma2
#

E_CONFIG_OPTS =

if ENABLE_EXTERNALLCD
E_CONFIG_OPTS += --with-graphlcd
endif

if ENABLE_EPLAYER3
E_CONFIG_OPTS += --enable-libeplayer3
endif

$(DEPDIR)/enigma2-pli-amiko.do_prepare:
	REVISION=""; \
	HEAD="last"; \
	DIFF="0"; \
	REPO="git://github.com/technic/amiko-e2-pli.git"; \
	rm -rf $(appsdir)/enigma2-nightly; \
	rm -rf $(appsdir)/enigma2-nightly.org; \
	rm -rf $(appsdir)/enigma2-nightly.newest; \
	rm -rf $(appsdir)/enigma2-nightly.patched; \
	clear; \
	echo ""; \
	echo "Choose between the following revisions:"; \
	echo "========================================================================================================"; \
	echo " 0) Newest                 - E2 Amiko-Pli gstreamer / libplayer3    (Can fail due to outdated patch)     "; \
	echo " 1) inactive"; \
	echo " 2) inactive"; \
	echo " 3) inactive"; \
	echo " 4) inactive"; \
	echo "========================================================================================================"; \
	echo "Media Framwork : $(MEDIAFW)"; \
	echo "External LCD   : $(EXTERNALLCD)"; \
	read -p "Select         : "; \
	[ "$$REPLY" == "0" ] && DIFF="0" && HEAD="last"; \
	[ "$$REPLY" == "1" ] && DIFF="1" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "2" ] && DIFF="2" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "3" ] && DIFF="3" && HEAD="" && REVISION=""; \
	[ "$$REPLY" == "4" ] && DIFF="4" && HEAD="" && REVISION=""; \
	echo "Revision       : "$$REVISION; \
	echo ""; \
	[ -d "$(archivedir)/enigma2-pli-amiko.git" ] && \
	(cd $(archivedir)/enigma2-pli-amiko.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/enigma2-pli-amiko.git" ] || \
	git clone -b $$HEAD $$REPO $(archivedir)/enigma2-pli-amiko.git; \
	cp -ra $(archivedir)/enigma2-pli-amiko.git $(appsdir)/enigma2-nightly.newest; \
	cp -ra $(archivedir)/enigma2-pli-amiko.git $(appsdir)/enigma2-nightly; \
	[ "$$REVISION" == "" ] || (cd $(appsdir)/enigma2-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.org; \
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-pli-amiko.$$DIFF.diff"
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/skin-pli-patch.diff"
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/Enigma2-amiko-Language.patch"
	cd $(appsdir)/enigma2-nightly && patch -p1 < "../../cdk/Patches/enigma2-pli-amiko-eplayer3.diff"
	cp -ra $(appsdir)/enigma2-nightly $(appsdir)/enigma2-nightly.patched
	touch $@

$(appsdir)/enigma2-pli-amiko/config.status: \
		bootstrap opkg ethtool libfreetype libexpat libpng libjpeg libgif  \
		libfribidi libid3tag libmad libsigc libreadline libdvbsipp python libxml2 libxslt \
		elementtree zope_interface twisted twistedweb2 twistedmail pyopenssl pythonwifi pilimaging pyusb pycrypto \
		lxml libxmlccwrap ncurses-dev libdreamdvd2 tuxtxt32bpp sdparm hotplug_e2  libmme_host libmmeimage \
		$(MEDIAFW_DEP) $(EXTERNALLCD_DEP)
	cd $(appsdir)/enigma2-nightly && \
		./autogen.sh && \
		sed -e 's|#!/usr/bin/python|#!$(hostprefix)/bin/python|' -i po/xml2po.py && \
		./configure \
			--build=$(build) \
			--host=$(target) \
			--with-libsdl=no \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--prefix=/usr \
			--bindir=/usr/bin \
			--sysconfdir=/etc \
			--with-boxtype=none \
			$(E_CONFIG_OPTS) \
			STAGING_INCDIR=$(hostprefix)/usr/include \
			STAGING_LIBDIR=$(hostprefix)/usr/lib \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PY_PATH=$(targetprefix)/usr \
			$(PLATFORM_CPPFLAGS)

$(DEPDIR)/enigma2-pli-amiko.do_compile: $(appsdir)/enigma2-pli-amiko/config.status
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/enigma2-pli-amiko: enigma2-pli-amiko.do_prepare enigma2-pli-amiko.do_compile
	$(MAKE) -C $(appsdir)/enigma2-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/bin/enigma2; \
	fi
	if [ -e $(targetprefix)/usr/local/bin/enigma2 ]; then \
		$(target)-strip $(targetprefix)/usr/local/bin/enigma2; \
	fi
	touch $@

enigma2-pli-amiko-clean:
	rm -f $(DEPDIR)/enigma2-pli-amiko
	rm -f $(DEPDIR)/enigma2-pli-amiko.do_compile
	cd $(appsdir)/enigma2-nightly && \
		$(MAKE) distclean

enigma2-pli-amiko-distclean:
	rm -f $(DEPDIR)/enigma2-pli-amiko
	rm -f $(DEPDIR)/enigma2-pli-amiko.do_compile
	rm -f $(DEPDIR)/enigma2-pli-amiko.do_prepare
	rm -rf $(appsdir)/enigma2-nightly
	rm -rf $(appsdir)/enigma2-nightly.newest
	rm -rf $(appsdir)/enigma2-nightly.org
	rm -rf $(appsdir)/enigma2-nightly.patched
