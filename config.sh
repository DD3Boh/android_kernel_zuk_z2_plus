KERNEL_DIR=$PWD
export ARCH=arm64
export SUBARCH=arm64

export KBUILD_BUILD_USER="Fedor917"
export KBUILD_BUILD_HOST="Zanovo"

export CROSS_COMPILE=/home/fedor917/android/aarch64-linux-android-4.9/bin/aarch64-linux-android-
#export STRIP=STRIP=/home/fedor917/android/aarch64-linux-android-4.9/bin/aarch64-linux-android-strip
MODULES_DIR=$KERNEL_DIR/out_modules

make lineageos_z2_plus_defconfig
#make menuconfig
#make oldconfig
#make -j8
make mrproper

