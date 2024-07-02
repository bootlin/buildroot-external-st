#!/bin/bash

fixup_extlinux_dtb_name()
{
	local DTB_NAME_PATH="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' ${BR2_CONFIG})"
	local DTB_NAME="$(basename ${DTB_NAME_PATH})"
	local EXTLINUX_PATH="${TARGET_DIR}/boot/extlinux/extlinux.conf"
	if [ ! -e ${EXTLINUX_PATH} ]; then
		echo "Can not find extlinux ${EXTLINUX_PATH}"
		exit 1
	fi

	sed -i -e "s/%DTB_NAME%/${DTB_NAME}/" ${EXTLINUX_PATH}
}

fixup_extlinux_dtb_name $@
