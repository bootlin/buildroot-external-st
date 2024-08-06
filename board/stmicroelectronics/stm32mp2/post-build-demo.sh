#!/bin/sh

set_rauc_info()
{
        local DTB_NAME="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' ${BR2_CONFIG} | cut -d '/' -f 2 | cut -d'.' -f1)"

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

set_rauc_info $@
create_data_dir $@
