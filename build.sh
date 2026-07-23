#!/bin/bash

#开启严格模式 / Enable strict mode
#遇到任何非零退出码的错误直接退出
#Exit immediately on non-zero exit code
#管道命令中任一失败则整体失败
#Fail pipeline if any command fails
set -eo pipefail

#1.定义颜色输出 / Define color outputs
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' #无颜色 / No Color

function msg() { echo -e "${GREEN}[INFO]${NC} $1"; }
function warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
function err() { echo -e "${RED}[ERROR]${NC} $1"; }

#2.依赖项与前置检查 / Dependencies and pre-checks
#检查基础依赖是否均已安装
#Check if basic dependencies are installed
msg "Checking required dependencies..."
for cmd in git curl zip make; do
    if ! command -v $cmd &> /dev/null; then
        err "Required command '$cmd' is not installed. Please install it first."
        exit 1
    fi
done

#3.工具链与环境变量设置
#3.Toolchain and environment settings
#确保编译器存在 / Ensure the compiler exists
if ! command -v "${CC:-clang}" &> /dev/null; then
    err "Compiler '${CC:-clang}' not found. Please check your environment."
    exit 1
fi

RESOURCE_DIR="$("${CC:-clang}" --print-resource-dir)"
TOOLCHAIN_PATH="$(dirname "$(dirname "$(dirname "$RESOURCE_DIR")")")"

#安全地获取 Git Commit ID / Safely get the Git Commit ID
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    GIT_COMMIT_ID=$(git rev-parse --short=8 HEAD)
else
    #不是 git 仓库，设置 COMMIT_ID 为 'unknown'
    #Not a git repository. Setting COMMIT_ID to 'unknown'
    warn "Not a git repository. Setting COMMIT_ID to 'unknown'."
    GIT_COMMIT_ID="unknown"
fi

#检查工具链路径是否有效
#Check if toolchain path is valid
if [ ! -d "$TOOLCHAIN_PATH" ]; then
    err "TOOLCHAIN_PATH [$TOOLCHAIN_PATH] does not exist."
    echo "Please ensure the toolchain is there, or change TOOLCHAIN_PATH in the script."
    exit 1
fi

msg "TOOLCHAIN_PATH: [$TOOLCHAIN_PATH]"
export PATH="$TOOLCHAIN_PATH:$PATH"

MAKE_ARGS="ARCH=arm64 O=out CC=clang LLVM=1 LLVM_IAS=1 LD=ld.lld CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip"

#3.1 主机端 OpenSSL 头文件检测 / Host OpenSSL headers detection
#部分环境未安装 libssl-dev，导致 scripts/extract-cert.c 等主机工具
#编译时找不到 <openssl/bio.h>。此处优先使用系统头文件，缺失时回退到
#预置的本地副本，避免构建在配置阶段即失败。
#Some environments lack libssl-dev, which breaks host tools such as
#scripts/extract-cert.c that include <openssl/bio.h>. Prefer the system
#headers and fall back to a bundled local copy when they are missing.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SSL_INCLUDE="$SCRIPT_DIR/../.build-deps/ssl-usr/include"
LOCAL_SSL_ARCH_INCLUDE="$SCRIPT_DIR/../.build-deps/ssl-usr/include/x86_64-linux-gnu"
if [ ! -f /usr/include/openssl/bio.h ]; then
    if [ -f "$LOCAL_SSL_INCLUDE/openssl/bio.h" ]; then
        warn "System openssl headers not found. Using local copy at [$LOCAL_SSL_INCLUDE]."
        #KBUILD_HOSTCFLAGS 在顶层 Makefile 中由 \$(HOSTCFLAGS) 拼接而成，
        #故通过环境变量导出即可同时追加多个 -I 路径（含架构相关的 opensslconf.h）。
        #KBUILD_HOSTCFLAGS is assembled from \$(HOSTCFLAGS) in the top-level
        #Makefile, so exporting it lets us append multiple -I paths at once,
        #including the arch-specific opensslconf.h location.
        export HOSTCFLAGS="-I$LOCAL_SSL_INCLUDE -I$LOCAL_SSL_ARCH_INCLUDE"
    else
        err "OpenSSL headers not found. Install libssl-dev or place headers under .build-deps/ssl-usr."
        exit 1
    fi
fi

#检查 Clang 版本 / Check Clang version
msg "Checking Clang version:"
clang --version

#导出构建变量 / Export build variables
export KBUILD_BUILD_USER="aryan"
export KBUILD_BUILD_HOST="curiousnom"
export KBUILD_LAST_COMMIT=${GIT_COMMIT_ID}

#4.强制清理逻辑 / Forced Clean Build logic
#执行强制清理以确保没有旧文件干扰
#Perform forced clean to ensure no old files interfere
msg "Performing cleanup of previous build files (Forced Clean)..."
rm -rf out/
rm -f error.log
mkdir -p out/

#5.准备 AnyKernel3 / Prepare AnyKernel3
msg "Preparing AnyKernel3..."
if [ -d "anykernel/.git" ]; then
    #AnyKernel3已克隆，跳过克隆
    #AnyKernel3 already cloned. Skipping clone.
    msg "AnyKernel3 already cloned. Skipping clone."
    #清理残留的打包内核文件以确保环境干净
    #Clean up residual packed kernel files to ensure a clean environment
    rm -rf anykernel/kernels/*
else
    #删除异常目录并重新克隆
    #Delete abnormal directory and clone again
    rm -rf anykernel  
    msg "Cloning AnyKernel3 for pipa..."
    git clone https://github.com/bcggxx/AnyKernel3 -b n0-A16 --single-branch --depth=1 anykernel
fi

#6.开始编译 / Start compilation
msg "Configuring for PIPA (pipa_defconfig)..."
make $MAKE_ARGS pipa_defconfig

#6.1 按内存动态计算并行度 / Compute parallelism based on available memory
#本工具链启用 thin-LTO + polly，单个 clang 进程峰值约 1.5~2GB。
#直接使用 -j$(nproc) 在低内存机器上会因并行 clang 实例过多导致 OOM /
#段错误（exit 139）。这里按可用内存估算安全的 -j，并允许通过 JOBS 环境变量覆盖。
#The toolchain enables thin-LTO + polly; each clang process peaks at ~1.5-2GB.
#Using -j$(nproc) on low-memory hosts triggers OOM / segfault (exit 139) under
#parallel load. Estimate a safe -j from available memory; allow override via JOBS.
if [ -z "${JOBS:-}" ]; then
    MEM_AVAIL_KB=$(awk '/MemAvailable:/ {print $2; exit}' /proc/meminfo 2>/dev/null || echo 0)
    SWAP_FREE_KB=$(awk '/SwapFree:/ {print $2; exit}' /proc/meminfo 2>/dev/null || echo 0)
    #每作业预算 1500000 KB（约 1.5GB），向下取整，至少 1
    #Per-job budget ~1.5GB; floor to an integer, minimum 1
    MEM_BASED_JOBS=$(( (MEM_AVAIL_KB + SWAP_FREE_KB) / 1500000 ))
    [ "$MEM_BASED_JOBS" -lt 1 ] && MEM_BASED_JOBS=1
    CPU_JOBS=$(nproc --all)
    if [ "$MEM_BASED_JOBS" -lt "$CPU_JOBS" ]; then
        JOBS=$MEM_BASED_JOBS
        warn "Low memory: capping parallelism to -j${JOBS} (cpus=${CPU_JOBS}, avail≈$((MEM_AVAIL_KB/1024))MB). Override with JOBS=<n>."
    else
        JOBS=$CPU_JOBS
    fi
fi
msg "Building with -j${JOBS}"

msg "Starting Kernel Build for PIPA..."
#记录开始时间以计算耗时
#Record start time to calculate duration
BUILD_START=$(date +"%s")

#编译主流程：输出同步到终端和错误日志
#Main build process: sync output to terminal and error log
make $MAKE_ARGS -j"${JOBS}" 2>&1 | tee error.log

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

#7.检查产物与打包 / Check artifacts and package
#检查构建产物 / Check build artifacts
if [ ! -f "out/arch/arm64/boot/Image" ]; then
    #如果核心镜像不存在则直接报错退出
    #Exit with error if the core Image does not exist
    err "The file [out/arch/arm64/boot/Image] does not exist. Build failed!"
    err "Check error.log for detailed failure reasons."
    exit 1
fi

msg "Kernel compiled successfully in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)."
msg "Packaging with AnyKernel3..."

mkdir -p anykernel/kernels/

#安全拷贝内核文件并做异常处理
#Safely copy kernel files and handle exceptions
cp out/arch/arm64/boot/Image anykernel/kernels/ || { err "Failed to copy Image."; exit 1; }

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

#进入 AnyKernel 目录打包
#Enter AnyKernel directory to package
cd anykernel || { err "Failed to enter anykernel directory."; exit 1; }

timestamp=$(date)
ZIP_FILENAME="Kernel_N0_pipa_A16_AOSP_MIUI_${timestamp}.zip"

#优化 zip 参数并排除多余文件
#Optimize zip parameters and exclude unnecessary files
#如果打包失败则报错退出
#Exit with error if packaging fails
if zip -r9 "$ZIP_FILENAME" ./* -x "*.git*" "*out*" "*.zip" > /dev/null; then
    mv "$ZIP_FILENAME" ../
else
    err "Failed to create flashable zip."
    exit 1
fi

cd ..

msg "Build for PIPA finished."
echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}Done! The flashable zip is: ./$ZIP_FILENAME ${NC}"
echo -e "${GREEN}=====================================================${NC}"
