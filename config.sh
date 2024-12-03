#!/bin/bash

# Derectory Default
MRT_DIR="${HOME}/MRT"

# Code Name Of Device
DEVICE_CODENAME="SM-G532G"

# Kernel Source
KERNEL_SOURCE="https://github.com/AnGgIt86/android_kernel_samsung_grandppltedx"
KERNEL_BRANCH="main"

# Directory kernel
KERNEL_DIR="${MRT_DIR}/${DEVICE_CODENAME}"

# Toolchain Directory
TC_SOURCE="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9"
TC_DIR="${MRT_DIR}/PLATFORM/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9"
TC_BRANCH="nougat-release"
# CLANG_DIR="${MRT_DIR}/toolchain/linux-x86/clang-r510928"
# GCC_64_DIR="${MRT_DIR}/toolchain/aarch64-linux-android-4.9"
# GCC_32_DIR="${MRT_DIR}/toolchain/arm-linux-androideabi-4.9"
AK3_SOURCE="https://github.com/AnGgIt86/AnyKernel3"
AK3_DIR="${MRT_DIR}/android/AnyKernel3"

# Default config
export PATH="${TC_DIR}/bin:${PATH}"
export KBUILD_BUILD_USER="M•R•T"
export KBUILD_BUILD_HOST="Project"
export KBUILD_BUILD_VERSION="1"

SECONDS=0 # builtin bash timer
ZIPNAME="MRT-Kernel-${DEVICE_CODENAME}-$(TZ=Asia/Jakarta date +"%Y%m%d-%H%M").zip"
DEFCONFIG="mt6737t-grandpplte_defconfig"

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
