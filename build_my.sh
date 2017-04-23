#!/bin/bash
export CONFIG_FILE="lightmoon_defconfig"
export ARCH="arm64"
export CROSS_COMPILE="aarch64-linux-android-"
export KBUILD_BUILD_USER="haha"
export KBUILD_BUILD_HOST="DD3Boh"
export TOOL_CHAIN_PATH="${HOME}/kernel/aarch64-linux-android-6.x/bin"
export CONFIG_ABS_PATH="arch/${ARCH}/configs/${CONFIG_FILE}"
export PATH=$PATH:${TOOL_CHAIN_PATH}
export objdir="${HOME}/kernel/zuk/lightmoon-obj"
export sourcedir="${HOME}/kernel/zuk/LightMoon"
export anykernel="${HOME}/kernel/zuk/lightmoon-anykernel"
compile() {
  make O=$objdir ARCH=arm64 CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE}  $CONFIG_FILE -j4
  make O=$objdir -j6
}
clean() {
  make O=$objdir ARCH=arm64 CROSS_COMPILE=${TOOL_CHAIN_PATH}/${CROSS_COMPILE}  $CONFIG_FILE -j4
  make O=$objdir mrproper
}
module_stock(){
  rm -rf $anykernel/modules/
  mkdir $anykernel/modules
  find $objdir -name '*.ko' -exec cp -av {} $anykernel/modules/ \;
  # strip modules
 ${TOOL_CHAIN_PATH}/${CROSS_COMPILE}strip --strip-unneeded $anykernel/modules/*
  cp -rf $objdir/arch/arm64/boot/Image.gz-dtb $anykernel/zImage
}
module_cm(){
  rm -rf $anykernel/modules/
  mkdir $anykernel/modules
  find $objdir -name '*.ko' -exec cp -av {} $anykernel/modules/ \;
  # strip modules
 ${TOOL_CHAIN_PATH}/${CROSS_COMPILE}strip --strip-unneeded $anykernel/modules/*
  cp -rf $objdir/arch/arm64/boot/Image.gz-dtb $anykernel/zImage
}
dtbuild(){
  cd $sourcedir
  ./tools/dtbToolCM -2 -o $objdir/arch/arm64/boot/dt.img -s 4096 -p $objdir/scripts/dtc/ $objdir/arch/arm64/boot/dts/
}
delete_zip(){
  cd $anykernel
  find . -name "*.zip" -type f
  find . -name "*.zip" -type f -delete
}
build_package(){
  zip -r9 UPDATE-AnyKernel2.zip * -x README UPDATE-AnyKernel2.zip
}
turn_back(){
cd $sourcedir
}
#clean
compile
module_stock
delete_zip
build_package
turn_back
#dtbuild
#cp $objdir/arch/arm64/boot/zImage $sourcedir/zImage
#cp $objdir/arch/arm64/boot/dt.img.lz4 $sourcedir/dt.img
