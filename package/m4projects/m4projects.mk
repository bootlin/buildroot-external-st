################################################################################
#
# m4projects
#
################################################################################

M4PROJECTS_VERSION = 1.5.0
M4PROJECTS_SITE = $(call github,STMicroelectronics,STM32CubeMP1,$(M4PROJECTS_VERSION))
M4PROJECTS_LICENSE = Apache-2.0, MIT, BSD-3-Clause
M4PROJECTS_LICENSE_FILES = License.md

M4PROJECTS_DEPENDENCIES += host-python host-arm-gnu-a-toolchain

M4PROJECTS_PROJECTS_LIST = \
	STM32MP157C-DK2/Examples/ADC/ADC_SingleConversion_TriggerTimer_DMA \
	STM32MP157C-DK2/Examples/Cortex/CORTEXM_MPU \
	STM32MP157C-DK2/Examples/CRC/CRC_UserDefinedPolynomial \
	STM32MP157C-DK2/Examples/CRYP/CRYP_AES_DMA \
	STM32MP157C-DK2/Examples/DMA/DMA_FIFOMode \
	STM32MP157C-DK2/Examples/GPIO/GPIO_EXTI \
	STM32MP157C-DK2/Examples/HASH/HASH_SHA224SHA256_DMA \
	STM32MP157C-DK2/Examples/I2C/I2C_TwoBoards_ComIT \
	STM32MP157C-DK2/Examples/LPTIM/LPTIM_PulseCounter \
	STM32MP157C-DK2/Examples/PWR/PWR_STOP_CoPro \
	STM32MP157C-DK2/Examples/SPI/SPI_FullDuplex_ComDMA_Master \
	STM32MP157C-DK2/Examples/SPI/SPI_FullDuplex_ComDMA_Slave \
	STM32MP157C-DK2/Examples/SPI/SPI_FullDuplex_ComIT_Master \
	STM32MP157C-DK2/Examples/SPI/SPI_FullDuplex_ComIT_Slave \
	STM32MP157C-DK2/Examples/TIM/TIM_DMABurst \
	STM32MP157C-DK2/Examples/UART/UART_TwoBoards_ComDMA \
	STM32MP157C-DK2/Examples/UART/UART_TwoBoards_ComIT \
	STM32MP157C-DK2/Examples/UART/UART_Receive_Transmit_Console \
	STM32MP157C-DK2/Examples/WWDG/WWDG_Example \
	STM32MP157C-DK2/Applications/OpenAMP/OpenAMP_raw \
	STM32MP157C-DK2/Applications/OpenAMP/OpenAMP_TTY_echo \
	STM32MP157C-DK2/Applications/FreeRTOS/FreeRTOS_ThreadCreation \
	STM32MP157C-DK2/Applications/CoproSync/CoproSync_ShutDown \
	STM32MP157C-DK2/Applications/OpenAMP/OpenAMP_TTY_echo_wakeup \
	STM32MP157C-DK2/Demonstrations/AI_Character_Recognition

M4PROJECTS_BUILD_CONFIG = Debug

M4PROJECTS_MAKE_FLAGS = \
	CROSS_COMPILE="$(HOST_DIR)/bin/arm-none-eabi-" \
	CPU_TYPE=M4 \
	BUILD_CONFIG=$(M4PROJECTS_BUILD_CONFIG)

define M4PROJECTS_CONFIGURE_CMDS
	cp -f $(M4PROJECTS_PKGDIR)/Makefile.stm32 $(@D)
	cp -f $(M4PROJECTS_PKGDIR)/parse_project_config.py $(@D)
	$(foreach project, $(M4PROJECTS_PROJECTS_LIST), \
		mkdir -p $(@D)/$(project)/out/$(M4PROJECTS_BUILD_CONFIG); \
		$(HOST_DIR)/bin/python $(@D)/parse_project_config.py \
			"$(@D)/Projects/$(project)/STM32CubeIDE/CM4" "$(M4PROJECTS_BUILD_CONFIG)" "$(@D)/$(project)"
	)
endef

define M4PROJECTS_BUILD_CMDS
	$(foreach project, $(M4PROJECTS_PROJECTS_LIST), \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
			BIN_NAME=$(notdir $(project)) PROJECT_DIR=$(@D)/$(project) \
			$(M4PROJECTS_MAKE_FLAGS) \
			-f $(@D)/Makefile.stm32 clean ; \
		$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
			BIN_NAME=$(notdir $(project)) PROJECT_DIR=$(@D)/$(project) \
			$(M4PROJECTS_MAKE_FLAGS) \
			-f $(@D)/Makefile.stm32 all
	)
endef

define M4PROJECTS_INSTALL_TARGET_CMDS
	$(foreach project, $(M4PROJECTS_PROJECTS_LIST), \
		mkdir -p $(TARGET_DIR)/usr/lib/Cube-M4-examples/$(notdir $(project))/lib/firmware/ ; \
		$(INSTALL) -D -m 0755 $(@D)/$(project)/out/$(M4PROJECTS_BUILD_CONFIG)/$(notdir $(project)).elf \
			$(TARGET_DIR)/usr/lib/Cube-M4-examples/$(notdir $(project))/lib/firmware/ ; \
		if [ -e $(@D)/Projects/$(project)/Remoteproc/fw_cortex_m4.sh ]; then \
			$(INSTALL) -m 0755 $(@D)/Projects/$(project)/Remoteproc/fw_cortex_m4.sh \
				$(TARGET_DIR)/usr/lib/Cube-M4-examples/$(notdir $(project)) ; \
		fi; \
		if [ -e $(@D)/Projects/$(project)/Remoteproc/README ]; then \
			$(INSTALL) -m 0755 $(@D)/Projects/$(project)/Remoteproc/README \
				$(TARGET_DIR)/usr/lib/Cube-M4-examples/$(notdir $(project)) ; \
		fi; \
	 )
endef

$(eval $(generic-package))
