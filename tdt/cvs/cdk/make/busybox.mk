#
# busybox
#
$(DEPDIR)/busybox.do_prepare: @DEPENDS_busybox@
	@PREPARE_busybox@
	cd @DIR_busybox@ && \
		patch -p1 < ../Patches/busybox-1.21.0-mdev.patch
	touch $@

$(DEPDIR)/busybox.do_compile: bootstrap $(DEPDIR)/busybox.do_prepare Patches/busybox.config$(if $(UFS912)$(UFS913)$(SPARK)$(SPARK7162),_nandwrite) | $(DEPDIR)/$(GLIBC_DEV)
	cd @DIR_busybox@ && \
		$(INSTALL) -m644 ../$(lastword $^) .config && \
		$(MAKE) all \
			CROSS_COMPILE=$(target)- \
			CFLAGS_EXTRA="$(TARGET_CFLAGS)"
	touch $@

$(DEPDIR)/busybox: \
$(DEPDIR)/%busybox: $(DEPDIR)/busybox.do_compile
	cd @DIR_busybox@ && \
		export CROSS_COMPILE=$(target)- && \
		@INSTALL_busybox@
#	@DISTCLEANUP_busybox@
	@[ "x$*" = "x" ] && touch $@ || true
	@TUXBOX_YAUD_CUSTOMIZE@
