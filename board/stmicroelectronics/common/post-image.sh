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
	sed -e "s/%ATFBIN%/${ATFBIN}/" \
		${BOARD_PATH}/flash.tsv > ${BINARIES_DIR}/flash.tsv

	ls -1 "${BOARD_PATH}" | grep -E "\.(bin|stm32)$" | xargs -I {} cp "${BOARD_PATH}/{}" ${BINARIES_DIR}

	exit $?
}

main $@
