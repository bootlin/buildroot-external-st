add_wifi_fw_symlinks()
{
	if ! grep -q "^BR2_PACKAGE_LINUX_FIRMWARE=y" ${BR2_CONFIG}; then
		return
	fi

	pushd ${TARGET_DIR}/lib/firmware/brcm
	for board in stm32mp157d-dk1 stm32mp157f-dk2 stm32mp135f-dk; do
		ln -sf brcmfmac43430-sdio.bin brcmfmac43430-sdio.st,${board}-mx.bin
	done
	popd
}

set_rauc_info()
{
	local DTB_NAME="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' ${BR2_CONFIG} | cut -d'.' -f1)"

	# Set RAUC compatible description to the kernel devicetree name
	sed -i -e "s/%RAUC_COMPATIBLE%/${DTB_NAME}/" ${TARGET_DIR}/etc/rauc/system.conf

	# Pass VERSION as an environment variable (eg: export from a top-level Makefile)
	# If VERSION is unset, fallback to the Buildroot version
	local RAUC_VERSION=${VERSION:-${BR2_VERSION_FULL}}

	# Create rauc version file
	echo "${RAUC_VERSION}" > ${TARGET_DIR}/etc/rauc/version
}

create_data_dir()
{
	if [ ! -d "${TARGET_DIR}/data" ]; then
		mkdir ${TARGET_DIR}/data
	fi
}

add_wifi_fw_symlinks $@
set_rauc_info $@
create_data_dir $@
