################################################################################
#
# eth-switch
#
################################################################################

ETH_SWITCH_VERSION = cc3610597153462dce3b207592354ef6c21d9bfe
ETH_SWITCH_SITE = https://github.com/STMicroelectronics/tttech-tsn-swch-content.git
ETH_SWITCH_SITE_METHOD = git

ETH_SWITCH_LICENCE = GPL-2.0+
ETH_SWITCH_LICENSE_FILES = tsn_sw_base.edge-lkm/GPL-2.txt

ETH_SWITCH_MODULE_SUBDIRS = tsn_sw_base.edge-lkm st.stm32-deip
ETH_SWITCH_MODULE_MAKE_OPTS = "platform=st sched=fsc sid=sid"

$(eval $(kernel-module))
$(eval $(generic-package))
