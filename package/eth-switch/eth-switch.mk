################################################################################
#
# eth-switch
#
################################################################################

ETH_SWITCH_VERSION = 1.6.8
ETH_SWITCH_SITE = $(call github,STMicroelectronics,tttech-tsn-swch-content,$(ETH_SWITCH_VERSION))

ETH_SWITCH_LICENCE = GPL-2.0+
ETH_SWITCH_LICENSE_FILES = tsn_sw_base.edge-lkm/GPL-2.txt

ETH_SWITCH_MODULE_SUBDIRS = tsn_sw_base.edge-lkm st.stm32-deip
ETH_SWITCH_MODULE_MAKE_OPTS = "platform=st sched=fsc sid=sid"

$(eval $(kernel-module))
$(eval $(generic-package))
