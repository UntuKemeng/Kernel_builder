#!/usr/bin/env bash

# Source Configs
source $CONFIG
cd ${KERNEL_DIR}

function info() {
    KERNEL_VERSION=$(cat $KERNEL_DIR/out/.config | grep Linux/arm | cut -d " " -f3)
    UTS_VERSION=$(cat $KERNEL_DIR/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
    TOOLCHAIN_VERSION=$(cat $KERNEL_DIR/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
    TRIGGER_SHA="$(git rev-parse HEAD)"
    LATEST_COMMIT="$(git log --pretty=format:'%s' -1)"
    COMMIT_BY="$(git log --pretty=format:'by %an' -1)"
    BRANCH="$(git rev-parse --abbrev-ref HEAD)"
}

function push() {
    cd ${HOME}
    ZIP=$(echo *.zip)
    curl -F document=@$ZIP "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="
==========================
<b>👤 Owner:</b> $KBUILD_BUILD_USER
<b>🏚️ Linux version:</b> $KERNEL_VERSION
<b>🌿 Branch:</b> $KERNEL_BRANCH
<b>🎁 Top commit:</b> $LATEST_COMMIT
<b>🧧 SHA1:</b> $(sha1sum "$ZIP" | cut -d' ' -f1)
<b>📚 MD5:</b> $(md5sum "$ZIP" | cut -d' ' -f1)
<b>👩‍💻 Commit author:</b> $COMMIT_BY
<b>🐧 UTS version:</b> $UTS_VERSION
<b>💡 Compiler:</b> $TOOLCHAIN_VERSION
==========================
<b>🔋 For all change, look in:</b> <a href=\"$KERNEL_SOURCE/commits/$KERNEL_BRANCH\">Here</a>

Compile took $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
}

function finerr() {
    cd ${HOME}
    curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendMessage" -d chat_id="$TG_CHAT_ID" \
	    -d "disable_web_page_preview=true" \
	    -d "parse_mode=html" \
        -d text="==============================%0A<b>    Building Kernel Failed [❌]</b>%0A=============================="
    curl -s -X POST "https://api.telegram.org/bot$TG_TOKEN/sendSticker" \
        -d sticker="CAACAgIAAx0CXjGT1gACDRRhYsUKSwZJQFzmR6eKz2aP30iKqQACPgADr8ZRGiaKo_SrpcJQIQQ" \
        -d chat_id="$TG_CHAT_ID"
    curl -F document=@build.log "https://api.telegram.org/bot$TG_TOKEN/sendDocument" \
        -F chat_id="$TG_CHAT_ID" \
        -F "disable_web_page_preview=true" \
        -F "parse_mode=html" \
        -F caption="Error log❗"
    exit 1
}

if [[ $1 = "-r" || $1 = "--regen" ]]; then
    make O=out ARCH=arm $DEFCONFIG savedefconfig
    cp out/defconfig arch/arm/configs/$DEFCONFIG
    exit
fi

if [[ $1 = "-c" || $1 = "--clean" ]]; then
    rm -rf out
fi

KBUILD_COMPILER_STRING="$("$TC_DIR"/bin/arm-linux-androideabi-gcc --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
echo ================================================
echo "              __  ______  ______              "
echo "             /  |/  / _ \/_  __/              "
echo "        __  / /|_/ / , _/ / /  __             "
echo "       /_/ /_/  /_/_/|_| /_/  /_/             "
echo "    ___  ___  ____     _________________      "
echo "   / _ \/ _ \/ __ \__ / / __/ ___/_  __/      "
echo "  / ___/ , _/ /_/ / // / _// /__  / /         "
echo " /_/  /_/|_|\____/\___/___/\___/ /_/          "
echo ================================================
echo BUILDER NAME = ${KBUILD_BUILD_USER}
echo BUILDER HOSTNAME = ${KBUILD_BUILD_HOST}
echo CONFIG NAME = ${DEFCONFIG}
echo TOOLCHAIN VERSION = ${KBUILD_COMPILER_STRING}
echo DATE = $(TZ=Asia/Jakarta date +"%Y%m%d-%H%M")
echo ================================================

mkdir -p out
make O=out ARCH=arm $DEFCONFIG

msg -e "\nStarting compilation...\n"
make -j$(nproc --all) O=out ARCH=arm \
    CROSS_COMPILE=${TC_DIR}/bin/arm-linux-androideabi- \
    CROSS_COMPILE_ARM32=${TC_DIR}/bin/arm-linux-androideabi-

if ! [ -f "out/arch/arm/boot/zImage" ]; then
    finerr
fi

if [ -f "out/arch/arm/boot/zImage" ]; then
    msg -e "\nKernel compiled succesfully! Zipping up...\n"
    if [ -d "$AK3_DIR" ]; then
        cp -r $AK3_DIR AnyKernel3
        elif ! git clone -q ${AK3_SOURCE}; then
        msg1 -e "\nAnyKernel3 repo not found locally and cloning failed! Aborting..."
        exit 1
    fi
    cp out/arch/arm/boot/zImage AnyKernel3
    rm -f *zip
    cd AnyKernel3
    git checkout master &> /dev/null
    zip -r9 "${HOME}/${ZIPNAME}" * -x '*.git*' README.md *placeholder
    cd ..
    rm -rf AnyKernel3
    rm -rf out/arch/arm/boot
    msg -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
    msg "Zip: ${ZIPNAME}"
    info
    push
    else
    msg1 -e "\nCompilation failed!"
    exit 1
fi
