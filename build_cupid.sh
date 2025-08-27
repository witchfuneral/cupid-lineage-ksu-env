# start build for cupid

export TARGET_BOARD_PLATFORM=cupid
export TARGET_BUILD_VARIANT=user
export ANDROID_BUILD_TOP=$(pwd)

export LTO=thin
BUILD_CONFIG=sm8450/build.config.cupid build/build.sh
