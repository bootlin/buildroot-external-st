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

main()
{
	local ATFBIN="$(atf_image)"
	if [ ! -e ${BINARIES_DIR}/${ATFBIN} ]; then
		echo "Can not find ATF binary ${ATFBIN}"
		exit 1
	fi
	local GENIMAGE_CFG=${2}
	local GENIMAGE_CFG_TMP="$(mktemp --suffix .genimage.cfg)"
	local GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
	local BOARD_PATH=$(dirname "${GENIMAGE_CFG}")

	sed -e "s/%ATFBIN%/${ATFBIN}/" \
		${GENIMAGE_CFG} > ${GENIMAGE_CFG_TMP}

	support/scripts/genimage.sh -c ${GENIMAGE_CFG_TMP}

	rm -f ${GENIMAGE_CFG_TMP}

	gzip -fk ${BINARIES_DIR}/sdcard.img
	${HOST_DIR}/bin/bmaptool create -o ${BINARIES_DIR}/sdcard.img.bmap ${BINARIES_DIR}/sdcard.img

        # Copy flash layout and necessary binary files
	case "${ATFBIN}" in
		*"stm32mp135"*)
			local FIP_FLASH="fip-stm32mp135_usb.bin"
			local ATF_FLASH="tf-a-stm32mp135_usb.stm32"
			;;
		*"stm32mp157"*)
			local FIP_FLASH="fip-stm32mp157_usb.bin"
			local ATF_FLASH="tf-a-stm32mp157_usb.stm32"
			;;
	esac
	sed -e "s/%ATFBIN%/${ATF_FLASH}/" -e "s/%FIPBIN%/${FIP_FLASH}/" \
		${BOARD_PATH}/flash.tsv > ${BINARIES_DIR}/flash.tsv

	cp ${BOARD_PATH}/${ATF_FLASH} ${BOARD_PATH}/${FIP_FLASH} ${BINARIES_DIR}

	exit $?
}

main $@
