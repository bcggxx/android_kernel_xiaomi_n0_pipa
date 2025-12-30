#!/bin/bash

# Ensure the script exits on error
set -e

TOOLCHAIN_PATH=$HOME/tc/bin
export PATH="$TOOLCHAIN_PATH:$PATH"

MAKE_ARGS="ARCH=arm64 O=out CC=clang LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip"

# Check clang is existing.
echo "[clang --version]:"
clang --version

rm -rf out/

make $MAKE_ARGS vendor/alioth_defconfig vendor/xiaomi/pipa.config

make $MAKE_ARGS savedefconfig

ls out/.config
ls out/defconfig

mv out/defconfig arch/arm64/configs/pipa_defconfig

echo Regenerated Defconfigs!
