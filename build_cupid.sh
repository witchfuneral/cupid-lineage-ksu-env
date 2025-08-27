# start build for cupid

export TARGET_BOARD_PLATFORM=cupid
export TARGET_BUILD_VARIANT=user
export ANDROID_BUILD_TOP=$(pwd)/gki-kernel

export LTO=thin
BUILD_CONFIG=gki-kernel/sm8450/build.config.cupid build/build.sh

echo "###"
echo "Build complete"
echo "###"
echo ""
echo "###"
echo "Setting up AnyKernel"
echo "###"

# clone anykernel and copy my anykernel config
git clone https://github.com/osm0sis/AnyKernel3 --depth=1
cp anykernel.sh AnyKernel3/anykernel.sh

# copy the kernel image
cp gki-kernel/out/android12-5.10/dist/Image AnyKernel3/Image

# create the AnyKernel installer
cd AnyKernel3
zip -0 -r cupid-ksu-lineage-$(date +"%Y-%m-%d").zip *
