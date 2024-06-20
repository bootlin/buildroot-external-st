generate_rauc_bundle()
{
        local DTB_NAME="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\(.*\)"$/\1/p' ${BR2_CONFIG} | cut -d '/' -f 2 | cut -d'.' -f1)"
	# Pass VERSION as an environment variable (eg: export from a top-level Makefile)
	# If VERSION is unset, fallback to the Buildroot version
	local RAUC_VERSION=${VERSION:-${BR2_VERSION_FULL}}
	local SCRIPT_PATH=$(dirname "$0")

	local RAUC_TMP=$(mktemp -d --suffix .rauc)
	cp ${SCRIPT_PATH}/manifest.raucm ${RAUC_TMP}/manifest.raucm
	sed -i -e "s/%RAUC_COMPATIBLE%/${DTB_NAME}/" ${RAUC_TMP}/manifest.raucm
	sed -i -e "s/%RAUC_VERSION%/${RAUC_VERSION}/" ${RAUC_TMP}/manifest.raucm

	cp ${BINARIES_DIR}/rootfs.squashfs ${RAUC_TMP}

	rm -f ${BINARIES_DIR}/rootfs.raucb
	${HOST_DIR}/bin/rauc bundle \
		--signing-keyring ${TARGET_DIR}/etc/rauc/ca.cert.pem \
		--cert ${TARGET_DIR}/etc/rauc/ca.cert.pem \
		--key ${SCRIPT_PATH}/ca.key.pem \
		${RAUC_TMP} \
		${BINARIES_DIR}/rootfs.raucb

	rm -rf ${RAUC_TMP}
}

generate_rauc_bundle $@
