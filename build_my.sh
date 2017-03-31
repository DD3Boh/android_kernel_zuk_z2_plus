#!/bin/bash
export CONFIG_FILE="darkmoon_defconfig"
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-android-"
export TOOL_CHAIN_PATH="/home/dd3/kernel/aarch64-linux-android-ub-4.9/bin"
export CONFIG_ABS_PATH="arch/${ARCH}/configs/${CONFIG_FILE}"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export objdir="${HOME}/kernel/zuk/obj"
export sourcedir="/home/dd3/kernel/zuk/msm8996"
compile() {
  make O=$objdir ARCH=arm64 CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE}  $CONFIG_FILE -j4
  make O=$objdir -j6
}
clean() {
  make O=$objdir ARCH=arm64 CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE}  $CONFIG_FILE -j4
  make O=$objdir mrproper
}
module_stock(){
  rm -rf /${HOME}/kernel/zuk/anykernel/modules/
  mkdir /${HOME}/kernel/zuk/anykernel/modules
  find $objdir -name '*.ko' -exec cp -av {} /${HOME}/kernel/zuk/anykernel/modules/ \;
  # strip modules
 ${TOOL_CHAIN_PATH}/${CROSS_COMPILE}strip --strip-unneeded ${HOME}/kernel/zuk/anykernel/modules/*
  mkdir /${HOME}/kernel/zuk/anykernel/modules/qca_cld
  mv /${HOME}/kernel/zuk/anykernel/modules/wlan.ko /${HOME}/kernel/zuk/anykernel/modules/qca_cld/qca_cld_wlan.ko
  cp -rf $objdir/arch/arm64/boot/Image.gz-dtb /${HOME}/kernel/zuk/anykernel/zImage
}
module_cm(){
  rm -rf /${HOME}/kernel/zuk/anykernel/modules/
  mkdir /${HOME}/kernel/zuk/anykernel/modules
  find $objdir -name '*.ko' -exec cp -av {} /${HOME}/kernel/zuk/anykernel/modules/ \;
  # strip modules
 ${TOOL_CHAIN_PATH}/${CROSS_COMPILE}strip --strip-unneeded ${HOME}/kernel/zuk/anykernel/modules/*
  cp -rf $objdir/arch/arm64/boot/Image.gz-dtb /${HOME}/kernel/zuk/anykernel/zImage
}
dtbuild(){
  cd $sourcedir
  ./tools/dtbToolCM -2 -o $objdir/arch/arm64/boot/dt.img -s 4096 -p $objdir/scripts/dtc/ $objdir/arch/arm64/boot/dts/
}
#clean
compile
module_stock
#dtbuild
#cp $objdir/arch/arm64/boot/zImage $sourcedir/zImage
#cp $objdir/arch/arm64/boot/dt.img.lz4 $sourcedir/dt.img
