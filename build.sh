#!/bin/bash

# Ensure the script exits on error
set -e

TOOLCHAIN_PATH=$HOME/tc/bin
GIT_COMMIT_ID=$(git rev-parse --short=8 HEAD)

if [ ! -d $TOOLCHAIN_PATH ]; then
    echo "TOOLCHAIN_PATH [$TOOLCHAIN_PATH] does not exist."
    echo "Please ensure the toolchain is there, or change TOOLCHAIN_PATH in the script to your toolchain path."
    exit 1
fi

echo "TOOLCHAIN_PATH: [$TOOLCHAIN_PATH]"
export PATH="$TOOLCHAIN_PATH:$PATH"

MAKE_ARGS="ARCH=arm64 O=out CC=clang LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip"

# Check clang is existing.
echo "[clang --version]:"
clang --version

# Export variables
export KBUILD_BUILD_USER="aryan"
export KBUILD_BUILD_HOST="curiousnom"
export KBUILD_LAST_COMMIT=${GIT_COMMIT_ID}

echo "Cleaning..."
rm -rf out/
rm -rf error.log

echo "Cloning AnyKernel3 for packing kernel..."
if [ -d "anykernel/.git" ]; then
    echo "AnyKernel3 already cloned. Skipping."
else
    rm -rf anykernel  # ensure clean state
    git clone https://github.com/CuriousNom/AnyKernel3 -b pipa-n0 --single-branch --depth=1 anykernel
fi

    # ------------- Building for PIPA ---------------
    echo "Clearing [out/] and building for PIPA....."

    make $MAKE_ARGS vendor/pipa_defconfig

    make $MAKE_ARGS -j$(nproc --all) 2> >(tee -a error.log >&2)

    if [ -f "out/arch/arm64/boot/Image" ]; then
        echo "The file [out/arch/arm64/boot/Image] exists. Built successfully."
    else
        echo "The file [out/arch/arm64/boot/Image] does not exist. Seems build failed."
        exit 1
    fi

    rm -rf anykernel/kernels/
    mkdir -p anykernel/kernels/
    cp out/arch/arm64/boot/Image anykernel/kernels/
    cp out/arch/arm64/boot/dtb anykernel/kernels/
    cp out/arch/arm64/boot/dtbo.img anykernel/kernels/

    cd anykernel
    ZIP_FILENAME=Kernel_n0_pipa_anykernel3_${GIT_COMMIT_ID}.zip
    zip -r9 $ZIP_FILENAME ./* -x .git .gitignore out/ ./*.zip
    mv $ZIP_FILENAME ../
    cd ..

    echo "Build for PIPA finished."

echo "Done. The flashable zip is: [./$ZIP_FILENAME]"
