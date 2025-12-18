#!/usr/bin/env bash

#
# atf_image extracts the ATF binary image from DTB_FILE_NAME that appears in
# BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES in ${BR_CONFIG},
# then prints the corresponding file name for the genimage
# configuration file
#
atf_image()
{
	local ATF_VARIABLES="$(sed -n 's/^BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES="\(.*\)"$/\1/p' ${BR2_CONFIG})"

	local DTB_NAME="$(sed -n 's/.*DTB_FILE_NAME=\([^ ]*\)/\1/p' <<< ${ATF_VARIABLES})"
	local STM_NAME="tf-a-$(cut -f1 -d'.' <<< ${DTB_NAME}).stm32"
	echo ${STM_NAME}
}

generate_sdcard()
{
	local ATFBIN="$(atf_image)"
	if [ ! -e ${BINARIES_DIR}/${ATFBIN} ]; then
		echo "Can not find ATF binary ${ATFBIN}"
		exit 1
	fi
	local GENIMAGE_CFG=${2}
	local GENIMAGE_CFG_TMP="$(mktemp --suffix .genimage.cfg)"
	local GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
	local fipa_uuid="$("$HOST_DIR"/bin/uuidgen)"
	local fipb_uuid="$("$HOST_DIR"/bin/uuidgen)"

	# https://elixir.bootlin.com/arm-trusted-firmware/v2.14.0/source/docs/plat/st/stm32mpus.rst#L72
	local fip_uuid_type="19d5df83-11b0-457b-be2c-7559c13142a5"

	# https://elixir.bootlin.com/u-boot/v2025.10/source/include/fwu.h#L97
	local mdata_uuid="8a7a84a0-8387-40f6-ab41-a8b9a5a60d23"

	# https://elixir.bootlin.com/arm-trusted-firmware/v2.14.0/source/plat/st/common/include/stm32mp_io_storage.h#L21
	local nor_fipa_uuid="4fd84c93-54ef-463f-a7ef-ae25ff887087"
	local nor_fipb_uuid="09c54952-d5bf-45af-acee-335303766fb3"

	sed -e "s/%ATFBIN%/${ATFBIN}/" -e "s/%FIPA_UUID%/${fipa_uuid}/" \
		-e "s/%FIPB_UUID%/${fipb_uuid}/" \
		-e "s/%FIP_UUID_TYPE%/${fip_uuid_type}/" \
		-e "s/%FWUMDATA_UUID%/${mdata_uuid}/" \
		${GENIMAGE_CFG} > ${GENIMAGE_CFG_TMP}

	${HOST_DIR}/bin/mkfwumdata -i 1 -b 2 -v 2 -g \
		${mdata_uuid},${fip_uuid_type},${fipa_uuid},${fipb_uuid} \
		${BINARIES_DIR}/mdata.bin

	${HOST_DIR}/bin/mkfwumdata -i 1 -b 2 -v 2 -g \
		${mdata_uuid},${fip_uuid_type},${nor_fipa_uuid},${nor_fipb_uuid} \
		${BINARIES_DIR}/mdata-nor.bin

	support/scripts/genimage.sh -c ${GENIMAGE_CFG_TMP}

	rm -f ${GENIMAGE_CFG_TMP}

	gzip -fk ${BINARIES_DIR}/sdcard.img
}

generate_sdcard $@
