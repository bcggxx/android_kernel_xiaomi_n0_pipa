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

MAKE_ARGS="ARCH=arm64 O=out CC=clang LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_COMPAT=arm-linux-gnueabi- AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip"

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
    git clone https://github.com/CuriousNom/AnyKernel3 -b pipa-n0 --single-branch --depth=1 anykernel
fi

#6.准备 KernelSU / Prepare KernelSU
#检测 kernelsu 目录是否存在且为有效 git 仓库
#Check if kernelsu directory exists and is a valid git repo
if [ -d "kernelsu" ] && [ ! -d "kernelsu/.git" ]; then
    warn "KernelSU directory exists but is not a valid git repository. Deleting..."
    rm -rf kernelsu
fi

if [ ! -d "kernelsu" ]; then
    #未找到 KernelSU 或判定无效则执行安装脚本
    #Run setup script if KernelSU is not found or invalid
    msg "KernelSU directory not found or invalid. Installing..."
    curl -LSs "https://github.com/ReSukiSU/ReSukiSU/raw/refs/heads/main/kernel/setup.sh" | bash -s main
else
    msg "KernelSU directory found. Checking for updates..."
    #增加出错退出机制防止目录跳转失败
    #Add exit on error to prevent failure of changing directory
    cd kernelsu || { err "Failed to enter kernelsu directory."; exit 1; }
    
    #获取远程最新分支的 commit hash
    #Get the latest commit hash of the remote branch
    REMOTE_HASH=$(git ls-remote https://github.com/ReSukiSU/ReSukiSU.git refs/heads/main | awk '{print $1}')
    LOCAL_HASH=$(git rev-parse HEAD)
    
    if [ -n "$REMOTE_HASH" ] && [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        msg "KernelSU is out of date. Syncing with upstream main..."
        git fetch origin main || warn "Failed to fetch from origin, checking upstream..."
        
        #使用 reset 强制同步远程状态
        #Use reset to strictly sync remote status
        #防止本地冲突导致脚本卡死
        #Prevent local conflicts from freezing the script
        git reset --hard origin/main || { err "Failed to update KernelSU."; exit 1; }
    elif [ -z "$REMOTE_HASH" ]; then
        #获取远程哈希失败，跳过更新检查
        #Failed to fetch remote hash. Skipping update check.
        warn "Failed to fetch remote KernelSU hash (Network issue?). Skipping update check."
    else
        msg "KernelSU is up to date."
    fi
    cd ..
fi

#7.开始编译 / Start compilation
msg "Configuring for PIPA (pipa_defconfig)..."
make $MAKE_ARGS pipa_defconfig

msg "Starting Kernel Build for PIPA..."
#记录开始时间以计算耗时
#Record start time to calculate duration
BUILD_START=$(date +"%s")

#编译主流程：输出同步到终端和错误日志
#Main build process: sync output to terminal and error log
make $MAKE_ARGS -j$(nproc --all) 2>&1 | tee error.log

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))

#8.检查产物与打包 / Check artifacts and package
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

timestamp=$(date +"%Y%m%d_%H%M%S")
ZIP_FILENAME="Kernel_n0_pipa_ak3_${timestamp}_${GIT_COMMIT_ID}.zip"

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