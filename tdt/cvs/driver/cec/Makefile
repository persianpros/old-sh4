ifeq ($(KERNELRELEASE),)
DRIVER_TOPDIR:=$(shell pwd)/..
include $(DRIVER_TOPDIR)/kernel.make
else
obj-m           += cec.o 
cec-objs        += cec_main.o cec_worker.o cec_opcodes.o cec_internal.o cec_proc.o cec_rc.o cec_dev.o

EXTRA_CFLAGS    := -I$(DRIVER_TOPDIR)/cec -I$(DRIVER_TOPDIR)/include -I$(DRIVER_TOPDIR)/dvb/drivers/media/dvb

ifdef UFS912
EXTRA_CFLAGS	+= -DSTx7111
endif

ifdef UFS913
EXTRA_CFLAGS	+= -DSTx7105
endif

ifdef HS7810A
EXTRA_CFLAGS	+= -DSTx7111
endif

ifdef HS7110
EXTRA_CFLAGS	+= -DSTx7111
endif

ifdef SPARK
EXTRA_CFLAGS	+= -DSTx7111
endif

ifdef SPARK7162
EXTRA_CFLAGS	+= -DSTx7105
endif

ifdef WHITEBOX
EXTRA_CFLAGS	+= -DSTx7111
endif

ifdef ATEVIO7500
EXTRA_CFLAGS	+= -DSTx7105
endif

ifdef HL101
EXTRA_CFLAGS	+= -DSTx7105
endif

endif

