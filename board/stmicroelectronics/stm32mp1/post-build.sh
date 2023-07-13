#!/bin/bash

fixup_extlinux_dtb_name()
{
	local DTB_NAME="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' ${BR2_CONFIG})"
	local EXTLINUX_PATH="${TARGET_DIR}/boot/extlinux/extlinux.conf"
	if [ ! -e ${EXTLINUX_PATH} ]; then
		echo "Can not find extlinux ${EXTLINUX_PATH}"
		exit 1
	fi

	sed -i -e "s/%DTB_NAME%/${DTB_NAME}/" ${EXTLINUX_PATH}
}

add_wifi_fw_symlinks()
{
	if ! grep -q "^BR2_PACKAGE_LINUX_FIRMWARE=y" ${BR2_CONFIG}; then
		return
	fi

	pushd ${TARGET_DIR}/lib/firmware/brcm
	for board in stm32mp157a-dk1 stm32mp157c-dk2 stm32mp157d-dk1 stm32mp157f-dk2 stm32mp135f-dk; do
		ln -sf brcmfmac43430-sdio.bin brcmfmac43430-sdio.st,${board}-mx.bin
	done
	popd
}

fixup_extlinux_dtb_name $@
add_wifi_fw_symlinks $@
