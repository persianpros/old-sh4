# Tuxbox drivers Makefile
# there are only three targets
#
# make all     - builds all modules
# make install - installs the modules
# make clean   - deletes modules recursively
#
# note that "clean" only works in the current
# directory while "all" and "install" will
# execute from the top dir.

ifeq ($(KERNELRELEASE),)
DRIVER_TOPDIR:=$(shell pwd)
include $(DRIVER_TOPDIR)/kernel.make
else
CCFLAGSY += -D__TDT__ -D__LINUX__ -D__SH4__ -D__KERNEL__ -DMODULE -DEXPORT_SYMTAB

CONFIGFILE := $(DRIVER_TOPDIR)/.config

include $(CONFIGFILE)


ifdef HL101
CCFLAGSY += -DHL101
else
CFLAGS += $(CCFLAGSY)
endif

export CCFLAGSY

obj-y := avs/
obj-y += multicom/
obj-y += stgfb/
obj-y += player2/
obj-y += boxtype/
obj-y += simu_button/
obj-y += e2_proc/
obj-y += frontends/
obj-y += frontcontroller/
obj-y += wireless/
obj-y += detect/

ifeq (,$(wildcard $(DRIVER_TOPDIR)/pti_np ))
obj-y += pti/
else
obj-y += pti_np/
endif

obj-y += compcache/
obj-y += bpamem/

ifdef HL101
obj-y += cec/
obj-y += cec_adb_box/
obj-y += cic/
obj-y += cpu_frequ/
obj-y += smartcard/
endif

endif
