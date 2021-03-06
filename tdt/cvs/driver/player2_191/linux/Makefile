TREE_ROOT?=$(DRIVER_TOPDIR)/player2
CONFIG_STGFB_PATH?=$(DRIVER_TOPDIR)/stgfb/stmfb

PART1=1

CCFLAGSY+=-DPLAYER2_PRIMARY_VIDEO_BUFFER_MEMORY=0x01B00000 \
		-DPLAYER2_SECONDARY_VIDEO_BUFFER_MEMORY=0x00000000 \
		-DPLAYER2_AVR_VIDEO_BUFFER_MEMORY=0x00000000 \
		-DPLAYER2_H264_MACROBLOCK_STRUCTURE_MEMORY=0x580000 \
		-DPLAYER2_H264_FRAME_MEMORY_SIZE=0x800000 \
		-DPLAYER2_H264_STREAM_PARAMETERS_COUNT=64 \
		-DPLAYER2_H264_FRAME_PARAMETERS_COUNT=64 \
		-DPLAYER2_AUDIO_DEFAULT_CODED_MEMORY_SIZE=0x500000 \
		-DPLAYER2_VIDEO_DEFAULT_CODED_MEMORY_SIZE=0x800000

# workaround for stm24
ifdef CONFIG_CPU_SUBTYPE_STX7100
CCFLAGSY+=-DCONFIG_CPU_SUBTYPE_STB7100
endif

CCFLAGSY+=-D__TDT__

CCFLAGSY+=-I$(CONFIG_KERNEL_BUILD)/include2 \
	-I$(CONFIG_KERNEL_BUILD)/include \
	-include $(KERNEL_LOCATION)/include/linux/autoconf.h \
	-I$(CONFIG_KERNEL_PATH)/include -D__KERNEL__

CCFLAGSY+=-I$(TREE_ROOT)/linux/components/inline         \
	-I$(TREE_ROOT)/components/include              \
	-I$(TREE_ROOT)/components/infrastructure       \
	-I$(TREE_ROOT)/linux/drivers/media/dvb/stm/allocator \
	-I$(TREE_ROOT)/linux/drivers/media/dvb/stm/h264_preprocessor \
	-I$(TREE_ROOT)/linux/drivers/stm/st_relay \
	-I$(TREE_ROOT)/linux/drivers/sound/ksound \
	-I$(TREE_ROOT)/linux/drivers/sound/pcm_transcoder

CCFLAGSY+=-I$(TREE_ROOT)/player/class_definitions        \
	-I$(TREE_ROOT)/player/buffer                   \
	-I$(TREE_ROOT)/player/demultiplexor            \
	-I$(TREE_ROOT)/player/collator                 \
	-I$(TREE_ROOT)/player/collator2                \
	-I$(TREE_ROOT)/player/frame_parser             \
	-I$(TREE_ROOT)/player/codec                    \
	-I$(TREE_ROOT)/player/standards                \
	-I$(TREE_ROOT)/player/manifestor               \
	-I$(TREE_ROOT)/player/player/                  \
	-I$(TREE_ROOT)/player/output_coordinator       \
	-I$(TREE_ROOT)/player/output_timer

CCFLAGSY+=-I$(CONFIG_STGFB_PATH)/
CCFLAGSY+=-I$(CONFIG_STGFB_PATH)/linux/include/

CCFLAGSY+=-I$(TREE_ROOT)/linux/include/

# promote CONFIG_RELAY to a CFLAGS define so that it can be observed by C++
# code as well and appropriate inlining performed at the earliest possible
# point.
ifdef CONFIG_RELAY
CCFLAGSY+=-DCONFIG_RELAY=1
endif

# CONFIG_DUAL_DISPLAY is a temporary hack to convert the existing
# picture-in-picture and speaker-in-speaker support into two
# independant displays also used for the compositor capture now.
ifdef CONFIG_DUAL_DISPLAY
CCFLAGSY+=-DCONFIG_DUAL_DISPLAY
endif

# promote CONFIG_MONITOR to a CFLAGS define so that it can be observed by C++
# code as well and appropriate inlining performed at the earliest possible
# point.
#ifdef CONFIG_MONITOR
CCFLAGSY+=-DCONFIG_MONITOR=1
#endif

# Finally pick up the original system headers, these must be near the '
# back' of the path to ensure the kernel headers are taken in
# preference to any system supplied ones. Items such as the MME header
# files (XXXX_DecoderTypes.h) form part of the system headers.
CCFLAGSY += -I$(CONFIG_MODULES_PATH)/usr/include

CCFLAGSY += -D__SH4__

CCFLAGSY += -DREPORT

ifneq (,$(findstring 2.6.3,$(KERNELVERSION)))
ccflags-y += $(CCFLAGSY)
else
CFLAGS += $(CCFLAGSY)
endif
export CCFLAGSY

## Start and end must be in their respective places.
## And this order dictates the module loading order
## for the unified driver.
obj-y += drivers/stm/unify-start/
obj-y += drivers/media/dvb/stm/mpeg2_hard_host_transformer/
obj-y += drivers/stm/monitor/
obj-y += drivers/media/sysfs/stm/
obj-y += drivers/sound/pseudocard/
obj-y += drivers/sound/ksound/
obj-y += drivers/media/dvb/stm/dvb/
obj-y += drivers/media/dvb/stm/backend/
obj-y += drivers/media/dvb/stm/h264_preprocessor/
obj-y += drivers/media/dvb/stm/allocator/
obj-y += drivers/sound/kreplay/
obj-y += drivers/sound/silencegen/
obj-y += drivers/sound/pcm_transcoder/
obj-y += drivers/stm/st_relay/
obj-y += drivers/stm/mmelog/
obj-y += drivers/stm/platform/
obj-y += drivers/stm/unify-end/

ifeq ($(CONFIG_PRINTK),)
CONFIG_STM_UNIFY:=n
endif

##CONFIG_STM_UNIFY can be set, or you can override
##individual drivers from the command line (or env variable)
ifeq ($(CONFIG_STM_UNIFY),y)
export CONFIG_STM_UNIFY_MONITOR_HAVANA:=y
export CONFIG_STM_UNIFY_PLAYER2:=y
export CONFIG_STM_UNIFY_STMSYSFS:=y
export CONFIG_STM_UNIFY_STMDVB:=y
export CONFIG_STM_UNIFY_STH264PP:=y
export CONFIG_STM_UNIFY_PLATFORM:=y
export CONFIG_STM_UNIFY_STMALLOC:=y
export CONFIG_STM_UNIFY_P2DIV64:=y
export CONFIG_STM_UNIFY_KSOUND:=y
export CONFIG_STM_UNIFY_PSEUDOCARD:=y
endif

ifeq ($(CONFIG_STM_UNIFY_KREPLAY),)
export CONFIG_STM_UNIFY_KREPLAY:=m
endif

ifeq ($(CONFIG_STM_UNIFY_MMELOG),)
export CONFIG_STM_UNIFY_MMELOG:=m
endif

ifeq ($(CONFIG_STM_UNIFY_STRELAY),)
export CONFIG_STM_UNIFY_STRELAY:=m
endif

ifeq ($(CONFIG_STM_UNIFY_MPEG2HW),)
export CONFIG_STM_UNIFY_MPEG2HW:=m
endif

ifeq ($(CONFIG_STM_UNIFY_SILENCEGEN),)
export CONFIG_STM_UNIFY_SILENCEGEN:=m
endif

ifeq ($(CONFIG_STM_UNIFY_PCM_TRANSCODER),)
export CONFIG_STM_UNIFY_PCM_TRANSCODER:=m
endif

ifeq ($(CONFIG_STM_UNIFY_PCM_KTONE),)
export CONFIG_STM_UNIFY_KTONE:=m
endif

ifeq ($(CONFIG_STM_UNIFY_MONITOR_HAVANA),)
export CONFIG_STM_UNIFY_MONITOR_HAVANA:=m
endif

ifeq ($(CONFIG_STM_UNIFY_PLAYER2),)
export CONFIG_STM_UNIFY_PLAYER2:=m
endif

ifeq ($(CONFIG_STM_UNIFY_STMSYSFS),)
export CONFIG_STM_UNIFY_STMSYSFS:=m
endif

ifeq ($(CONFIG_STM_UNIFY_STMDVB),)
export CONFIG_STM_UNIFY_STMDVB:=m
endif

ifeq ($(CONFIG_STM_UNIFY_STH264PP),)
export CONFIG_STM_UNIFY_STH264PP:=m
endif

ifeq ($(CONFIG_STM_UNIFY_PLATFORM),)
export CONFIG_STM_UNIFY_PLATFORM:=m
endif

ifeq ($(CONFIG_STM_UNIFY_STMALLOC),)
export CONFIG_STM_UNIFY_STMALLOC:=m
endif

ifeq ($(CONFIG_STM_UNIFY_P2DIV64),)
export CONFIG_STM_UNIFY_P2DIV64:=m
endif

ifeq ($(CONFIG_STM_UNIFY_KSOUND),)
export CONFIG_STM_UNIFY_KSOUND:=m
endif

ifeq ($(CONFIG_STM_UNIFY_PSEUDOCARD),)
export CONFIG_STM_UNIFY_PSEUDOCARD:=m
endif

player2-unified-objs:= unified.o built-in.o
obj-m += player2-unified.o

KBUILD_BUILTIN:=1
