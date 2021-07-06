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

	if grep -Eq "DTB_FILE_NAME=stm32mp157c-dk2.dtb" <<< ${ATF_VARIABLES}; then
		echo "tf-a-stm32mp157c-dk2.stm32"
	elif grep -Eq "DTB_FILE_NAME=stm32mp157a-dk1.dtb" <<< ${ATF_VARIABLES}; then
                echo "tf-a-stm32mp157a-dk1.stm32"
	elif grep -Eq "DTB_FILE_NAME=stm32mp157a-avenger96.dtb" <<< ${ATF_VARIABLES}; then
                echo "tf-a-stm32mp157a-avenger96.stm32"
	fi
}

main()
{
	local ATFBIN="$(atf_image)"
	local GENIMAGE_CFG="$(mktemp --suffix genimage.cfg)"
	local GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
	local SCRIPT_PATH=$(dirname "$0")

	sed -e "s/%ATFBIN%/${ATFBIN}/" \
		${SCRIPT_PATH}/genimage.cfg > ${GENIMAGE_CFG}

	support/scripts/genimage.sh -c ${GENIMAGE_CFG}

	rm -f ${GENIMAGE_CFG}

	exit $?
}

main $@
