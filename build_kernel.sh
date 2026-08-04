#!/bin/bash
TIME=$(date +%Y%m%d-%H%M)

if [ -e $(pwd)/AnyKernel3 ]
then
echo "AnyKernel exist skip Download AnyKernel3"
else
git clone https://github.com/Takumi123w/AnyKernel3.git
fi

# Change to 15.3 for no reason
TOOLCHAIN=$(pwd)/arm-gnu-toolchain-15.3.rel1-x86_64-arm-none-linux-gnueabihf/bin

export CROSS_COMPILE=$TOOLCHAIN/arm-none-linux-gnueabihf-
export CC=$TOOLCHAIN/arm-none-linux-gnueabihf-gcc
export PATH=$TOOLCHAIN:$PATH
export ARCH=arm

export KCFLAGS=-w
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y a01core_defconfig
ionice -c3 nice -n 19 make -C $(pwd) O=$(pwd)/out KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j$(($(nproc) - 1))

cp out/arch/arm/boot/Image $(pwd)/arch/arm/boot/Image
cp out/arch/arm/boot/Image $(pwd)/arch/arm64/boot/Image

# AnyKernel3 Repack
rm -rf $(pwd)/AnyKernel3/Image
cp out/arch/arm/boot/Image $(pwd)/AnyKernel3/Image
cd AnyKernel3
zip -r9 "Kernel-Repack-$TIME.zip" * -x .git *.zip README.md *placeholder
