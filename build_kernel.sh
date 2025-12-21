#!/bin/bash
TIME=$(date +%Y%m%d-%H%M)

if [ -e $(pwd)/AnyKernel3 ]
then
echo "AnyKernel exist skip Download AnyKernel3"
else
git clone https://github.com/Takumi123w/AnyKernel3.git
fi

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
zip -r9 "Kernel-Repack-$TIME.zip" * -x .git README.md *placeholder
