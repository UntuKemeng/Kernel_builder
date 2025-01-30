#!/bin/bash

# Derectory Default
MRT_DIR="${HOME}/MRT"

# Code Name Of Device
DEVICE_CODENAME="1938"

# Kernel Source
KERNEL_SOURCE="https://github.com/vivo-devs/kernel_vivo_mt6765"
KERNEL_BRANCH="master"

# Directory kernel
KERNEL_DIR="${MRT_DIR}/${DEVICE_CODENAME}"

# Toolchain Directory
TC_SOURCE="https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone"
TC_DIR="${MRT_DIR}/PLATFORM/prebuilts/linux-x86/clang-r522817"
TC_BRANCH="18"
AK3_SOURCE="https://github.com/AnGgIt86/AnyKernel3"
AK3_DIR="${MRT_DIR}/android/AnyKernel3"

# Default config
export PATH="${TC_DIR}/bin:${PATH}"
export KBUILD_BUILD_USER="vivo"
export KBUILD_BUILD_HOST="AnGgIt86"
export KBUILD_BUILD_VERSION="1"

SECONDS=0 # builtin bash timer
ZIPNAME="UWU-Kernel-${DEVICE_CODENAME}-$(TZ=Asia/Jakarta date +"%Y%m%d-%H%M").zip"
DEFCONFIG="k65v1_64_bsp_defconfig_PD1987F_EX"

# green
msg() {
    echo -e "\e[1;32m$*\e[0m"
}
# red
msg1() {
    echo -e "\e[1;31m$*\e[0m"
}
# yellow
msg2() {
    echo -e "\e[1;33m$*\e[0m"
}
# purple
msg3() {
    echo -e "\e[1;35m$*\e[0m"
}
