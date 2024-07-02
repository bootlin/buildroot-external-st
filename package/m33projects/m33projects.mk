################################################################################
#
# m33projects
#
################################################################################

M33PROJECTS_VERSION = bf7714ca90c9c4be615ffbe7aeeca556af4bb06e
M33PROJECTS_SITE = $(call github,STMicroelectronics,STM32CubeMP2,$(M33PROJECTS_VERSION))
M33PROJECTS_LICENSE = Apache-2.0, MIT, BSD-3-Clause
M33PROJECTS_LICENSE_FILES = License.md

M33PROJECTS_DEPENDENCIES += \
	host-arm-gnu-toolchain \
	optee-os \
	trusted-firmware-m \
	host-python-pycryptodomex

M33PROJECTS_PROJECTS_LIST = \
	STM32MP257F-EV1/Demonstrations/USBPD_DRP_UCSI

define M33PROJECTS_CONFIGURE_CMDS
	$(foreach project, $(M33PROJECTS_PROJECTS_LIST), \
		PATH=$(BR_PATH) \
		CROSS_COMPILE="$(HOST_DIR)/bin/arm-none-eabi-" \
		$(BR2_CMAKE) -S "$(@D)/Projects/$(project)" \
			-B "$(@D)/Projects/$(project)/build"
	)

endef
define M33PROJECTS_BUILD_CMDS
	$(foreach project, $(M33PROJECTS_PROJECTS_LIST), \
		cd "$(@D)/Projects/$(project)/build" ; \
		PATH=$(BR_PATH) $(MAKE) all
	)
endef

define M33PROJECTS_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/lib/firmware/
	$(foreach project, $(M33PROJECTS_PROJECTS_LIST), \
		$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/lib/Cube-M33-examples/$(notdir $(project)) ; \
		$(INSTALL) -D -m 0755 $(@D)/Projects/$(project)/build/$(notdir $(project))_CM33_NonSecure.elf \
			$(TARGET_DIR)/lib/firmware/ ; \
		PATH=$(BR_PATH) \
		TA_DEV_KIT_DIR=$(STAGING_DIR)/lib/optee/export-ta_arm64/ \
		OBJCOPY=$(HOST_DIR)/bin/arm-none-eabi-objcopy \
			$(M33PROJECTS_PKGDIR)st_copro_firmware_signature.sh \
			--input-nsecure $(@D)/Projects/$(project)/build/$(notdir $(project))_CM33_NonSecure.elf \
			--input-secure $(BINARIES_DIR)/tfm_s.elf \
			--signature-key $(STAGING_DIR)/lib/optee/export-ta_arm64/keys/default.pem \
			--output $(TARGET_DIR)/lib/firmware/$(notdir $(project))_CM33_NonSecure ; \
		$(INSTALL) -m 0755 $(M33PROJECTS_PKGDIR)fw_cortex_m33.sh \
			$(TARGET_DIR)/usr/lib/Cube-M33-examples/$(notdir $(project)) ;
	 )
endef

$(eval $(generic-package))
