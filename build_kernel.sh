#!/bin/bash

# KSU NEXT Download
if [ -e $(pwd)/KernelSU-Next ]
then
echo "Skip download KernelSU-Next because already have"
else
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -
fi

#########################
# KERNELSU Configuration#
#########################

# Replace arch for 32bit support
cp -rf $(pwd)/arch.h $(pwd)/KernelSU-Next/kernel
# Replace path for allowlist for A01 Core fix bugs
sed -i 's|#define KERNEL_SU_ALLOWLIST "/data/adb/ksu/.allowlist"|#define KERNEL_SU_ALLOWLIST "/data/.allowlist"|g' $(pwd)/KernelSU-Next/kernel/allowlist.c
# Write permission for file .allowlist change to 664 for writeable file
sed -i 's|ksu_filp_open_compat(KERNEL_SU_ALLOWLIST, O_WRONLY | O_CREAT | O_TRUNC, 0644);|ksu_filp_open_compat(KERNEL_SU_ALLOWLIST, O_WRONLY | O_CREAT | O_TRUNC, 0664);|g' $(pwd)/KernelSU-Next/kernel/allowlist.c

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
