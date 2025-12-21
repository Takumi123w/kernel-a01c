#!/bin/bash
TIME=$(date +%Y%m%d-%H%M)

# KSU Download
if [ -e $(pwd)/KernelSU ]
then
echo "KSU exist skip Download KSU"
else
curl -LSs "https://raw.githubusercontent.com/rsuntk/KernelSU/main/kernel/setup.sh" | bash -s v3.0.0-30-legacy
fi

if [ -e $(pwd)/AnyKernel3 ]
then
echo "AnyKernel exist skip Download AnyKernel3"
else
git clone https://github.com/Takumi123w/AnyKernel3.git
fi

# Patch for fix allow list a01core
sed -i 's|#define KERNEL_SU_ALLOWLIST "/data/adb/ksu/.allowlist"|#define KERNEL_SU_ALLOWLIST "/data/.allowlist"|g' "$(pwd)/KernelSU/kernel/allowlist.c"
sed -i 's|O_TRUNC, 0644|O_TRUNC, 0664|g' "$(pwd)/KernelSU/kernel/allowlist.c"

export CROSS_COMPILE=$(pwd)/arm-linux-androideabi-4.9/bin/arm-linux-androidkernel-
export CC=$(pwd)/arm-linux-androideabi-4.9/bin/arm-linux-androidkernel-gcc
export CLANG_TRIPLE=arm-linux-androidkernel-gcc
export ARCH=arm

export KCFLAGS=-w
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y a01core_defconfig
make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j16

cp out/arch/arm/boot/Image $(pwd)/arch/arm/boot/Image
cp out/arch/arm/boot/Image $(pwd)/arch/arm64/boot/Image

# AnyKernel3 Repack
rm -rf $(pwd)/AnyKernel3/Image
cp out/arch/arm/boot/Image $(pwd)/AnyKernel3/Image
cd AnyKernel3
zip -r9 "Kernel-Repack-KSU-$TIME.zip" * -x .git README.md *placeholder
