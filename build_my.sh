#!/bin/bash
export CONFIG_FILE="darkmoon_defconfig"
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-android-"
export TOOL_CHAIN_PATH="/home/dd3/kernel/aarch64-linux-android-ub-4.9/bin"
export CONFIG_ABS_PATH="arch/${ARCH}/configs/${CONFIG_FILE}"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export objdir="${HOME}/kernel/zuk/obj"
export sourcedir="/home/dd3/kernel/zuk/msm8996"
export anykernel="/home/dd3/kernel/kernel/anykernel"
compile() {
  make O=$objdir ARCH=arm64 CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE}  $CONFIG_FILE -j4
  make O=$objdir -j6
}
clean() {
  make O=$objdir ARCH=arm64 CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE}  $CONFIG_FILE -j4
  make O=$objdir mrproper
}
module_stock(){
  rm -rf ${HOME}/kernel/kernel/anykernel/modules/
  mkdir ${HOME}/kernel/kernel/anykernel/modules
  find $objdir -name '*.ko' -exec cp -av {} ${HOME}/kernel/kernel/anykernel/modules/ \;
  # strip modules
 ${TOOL_CHAIN_PATH}/${CROSS_COMPILE}strip --strip-unneeded ${HOME}/kernel/kernel/anykernel/modules/*
  cp -rf $objdir/arch/arm64/boot/Image.gz-dtb ${HOME}/kernel/kernel/anykernel/zImage
}
module_cm(){
  rm -rf ${HOME}/kernel/kernel/anykernel/modules/
  mkdir ${HOME}/kernel/kernel/anykernel/modules
  find $objdir -name '*.ko' -exec cp -av {} ${HOME}/kernel/kernel/anykernel/modules/ \;
  # strip modules
 ${TOOL_CHAIN_PATH}/${CROSS_COMPILE}strip --strip-unneeded ${HOME}/kernel/kernel/anykernel/modules/*
  cp -rf $objdir/arch/arm64/boot/Image.gz-dtb ${HOME}/kernel/kernel/anykernel/zImage
}
dtbuild(){
  cd $sourcedir
  ./tools/dtbToolCM -2 -o $objdir/arch/arm64/boot/dt.img -s 4096 -p $objdir/scripts/dtc/ $objdir/arch/arm64/boot/dts/
}
build_package(){
  cd $anykernel
  zip -r9 UPDATE-AnyKernel2.zip * -x README UPDATE-AnyKernel2.zip
}
#clean
compile
module_stock
build_package
#dtbuild
#cp $objdir/arch/arm64/boot/zImage $sourcedir/zImage
#cp $objdir/arch/arm64/boot/dt.img.lz4 $sourcedir/dt.img
