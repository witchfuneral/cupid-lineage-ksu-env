#!/bin/sh

# this script checks for the required toolchains (also installs if required), and pulls all the repos required for compiling the GKI kernel for xiaomi-cupid.

## setup all variables
# for distro checking
source /etc/os-release

ROOTDIR=$(pwd)

UBUNTU_PACKAGES="gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu rsync wget curl clang bc ccache repo"
ARCH_PACKAGES="aarch64-linux-gnu-gcc aarch64-linux-gnu-binutils rsync wget curl clang bc ccache repo"
# need to figure out fedora's packages
# FEDORA_PACKAGES=""

# functions
ubuntu_install(){
	sudo apt install $UBUNTU_PACKAGES -y
}

arch_install(){
	sudo pacman -S $ARCH_PACKAGES --noconfirm
}

# making all directories
mkdir gki-kernel anykernel kernel-out

echo "###"
echo "Installing packages"
echo "###"

if [[ $NAME == "Arch Linux" ]]; then
  arch_install
elif [[ $NAME == "Ubuntu" ]]; then
  ubuntu_install
else
  echo "Your distro might not be currently supported, sorry."
  echo "The script will continue in 5 seconds assuming you have the packages installed."
  echo "(ctrl+c to cancel)"
  sleep 5
fi

# initialize GKI repos from Google
cd gki-kernel
echo "###"
echo "Initializing repos."
echo "Enter a username for the repo command. If you don't do this, the sync will fail and the script will stop."
echo -n "Enter username: " && read $GIT_NAME
echo "Enter an email address for the repo command."
echo -n "Enter email: " && read $GIT_EMAIL

git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"

repo init -u https://android.googlesource.com/kernel/manifest/ -b common-android12-5.10-2025-09 --depth 1

# add cupid's repo manifest
mkdir .repo/local_manifests
cp $ROOTDIR/cupid.xml .repo/local_manifests/

# sync all repos
repo sync -j$(nproc --all)

# once the repo sync is complete, move the defconfig to it's destination
cp $ROOTDIR/cupid_defconfig sm8450/arch/arm64/configs/

# move build.config.cupid
cp $ROOTDIR/build.config.cupid sm8450/

# add KernelSU support
cd $ROOTDIR/gki-kernel/sm8450
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -

# copy kernel build script to the GKI folder
cp $ROOTDIR/build_cupid.sh $ROOTDIR/gki-kernel/

# done!
echo "###"
echo "Environment setup done."
echo "###"

cd $ROOTDIR/gki-kernel

echo "###"
echo "Build the kernel by running './build_cupid.sh'"
echo "###"
