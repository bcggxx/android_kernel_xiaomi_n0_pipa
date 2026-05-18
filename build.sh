#!/bin/bash

# Ensure the script exits on error / 确保脚本在遇到错误时退出
set -e

# --- 1. Define color outputs / 定义颜色输出 ---
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color / 无颜色

function msg() { echo -e "${GREEN}[INFO]${NC} $1"; }
function warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
function err() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- 2. Toolchain and environment variable settings / 工具链与环境变量设置 ---
RESOURCE_DIR="$("${CC:-clang}" --print-resource-dir)"
TOOLCHAIN_PATH="$(dirname "$(dirname "$(dirname "$RESOURCE_DIR")")")"

# Safely get the Git Commit ID / 安全地获取 Git Commit ID
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    GIT_COMMIT_ID=$(git rev-parse --short=8 HEAD)
else
    warn "Not a git repository. Setting COMMIT_ID to 'unknown'."
    GIT_COMMIT_ID="unknown"
fi

if [ ! -d "$TOOLCHAIN_PATH" ]; then
    err "TOOLCHAIN_PATH [$TOOLCHAIN_PATH] does not exist."
    echo "Please ensure the toolchain is there, or change TOOLCHAIN_PATH in the script."
    exit 1
fi

msg "TOOLCHAIN_PATH: [$TOOLCHAIN_PATH]"
export PATH="$TOOLCHAIN_PATH:$PATH"

MAKE_ARGS="ARCH=arm64 O=out CC=clang LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip"

# Check if Clang exists / 检查 Clang 是否存在
msg "Checking Clang version:"
clang --version

# Export build variables / 导出构建变量
export KBUILD_BUILD_USER="aryan"
export KBUILD_BUILD_HOST="curiousnom"
export KBUILD_LAST_COMMIT=${GIT_COMMIT_ID}

# --- 3. Pre-build clean logic (supports incremental build) / 编译前清理逻辑（支持增量编译） ---
if [ "$1" = "clean" ]; then
    msg "Cleaning output directories (Clean Build)..."
    rm -rf out/
    rm -rf error.log
else
    msg "Keeping output directories (Incremental Build). Run with './build.sh clean' for a clean build."
    # Always clean the old error log / 每次依然清理旧的错误日志
    rm -f error.log 
fi

# --- 4. Prepare AnyKernel3 / 准备 AnyKernel3 ---
msg "Preparing AnyKernel3..."
if [ -d "anykernel/.git" ]; then
    msg "AnyKernel3 already cloned. Skipping."
else
    # Ensure a clean state / 确保状态干净
    rm -rf anykernel  
    msg "Cloning AnyKernel3 for pipa..."
    git clone https://github.com/CuriousNom/AnyKernel3 -b pipa-n0 --single-branch --depth=1 anykernel
fi

# --- 5. Start compilation / 开始编译 ---
msg "Building for PIPA..."
make $MAKE_ARGS pipa_defconfig

# Record the start time to calculate the duration / 记录开始时间以计算耗时
BUILD_START=$(date +"%s")

# Main compilation process / 编译主流程
make $MAKE_ARGS -j$(nproc --all) 2> >(tee -a error.log >&2)

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

# --- 6. Check artifacts and package / 检查产物与打包 ---
if [ -f "out/arch/arm64/boot/Image" ]; then
    msg "Kernel compiled successfully in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)."
else
    err "The file [out/arch/arm64/boot/Image] does not exist. Build failed."
    err "Check error.log for details."
    exit 1
fi

msg "Packaging with AnyKernel3..."
rm -rf anykernel/kernels/
mkdir -p anykernel/kernels/

# Safely copy kernel files to prevent script interruption due to missing dtb/dtbo
# / 安全拷贝内核文件（防止因为缺失 dtb/dtbo 导致脚本中断）
cp out/arch/arm64/boot/Image anykernel/kernels/

if [ -f "out/arch/arm64/boot/dtb" ]; then
    cp out/arch/arm64/boot/dtb anykernel/kernels/
else
    warn "dtb not found, skipping."
fi

if [ -f "out/arch/arm64/boot/dtbo.img" ]; then
    cp out/arch/arm64/boot/dtbo.img anykernel/kernels/
else
    warn "dtbo.img not found, skipping."
fi

# Enter the AnyKernel directory to package / 进入 AnyKernel 目录打包
cd anykernel
timestamp=$(date +"%Y%m%d_%H%M%S")
ZIP_FILENAME="Kernel_n0_pipa_anykernel3_${timestamp}.zip"

# Optimized zip exclude rules to ensure useless files are not packaged
# / 优化了 zip 的排除规则，确保不会打包无用文件
zip -r9 "$ZIP_FILENAME" ./* -x "*.git*" "*out*" "*.zip" > /dev/null
mv "$ZIP_FILENAME" ../
cd ..

msg "Build for PIPA finished."
echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}Done! The flashable zip is: ./$ZIP_FILENAME ${NC}"
echo -e "${GREEN}=====================================================${NC}"