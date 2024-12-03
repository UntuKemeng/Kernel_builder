#!/usr/bin/env bash

# Source Configs
source $CONFIG

if ! [ -d "${KERNEL_DIR}" ]; then
    msg "Clonning kernel source..."
    if ! git clone ${KERNEL_SOURCE} -b ${KERNEL_BRANCH} ${MRT_DIR}/${DEVICE_CODENAME}; then
        msg1 "Cloning failed! Aborting..."
        exit 1
    fi
fi

# if ! [ -d "${CLANG_DIR}" ]; then
    # msg "Clonning toolchain clang..."
    # if ! git clone --depth 1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 ${TC_DIR}; then
        # msg1 "Cloning failed! Aborting..."
        # exit 1
    # fi
# fi

# if ! [ -d "${GCC_64_DIR}" ]; then
    # msg "Clonning gcc toolchain arm64..."
    # if ! git clone --depth=1 -b lineage-19.1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9.git ${GCC_64_DIR}; then
        # msg1 "Cloning failed! Aborting..."
        # exit 1
    # fi
# fi

if ! [ -d "${TC_DIR}" ]; then
    msg "Clonning gcc toolchain arm..."
    if ! git clone --depth=1 -b ${TC_BRANCH} ${TC_SOURCE} ${TC_DIR}; then
        msg1 "Cloning failed! Aborting..."
        exit 1
    fi
fi
