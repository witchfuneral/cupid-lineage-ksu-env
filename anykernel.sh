### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=KernelSU for LineageOS-cupid
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=cupid
supported.versions=15
'; } # end properties

# boot shell variables
BLOCK=/dev/block/by-name/boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

## AnyKernel boot install
# use split_boot instead of dump_boot and flash_boot instead of write_boot
# to skip ramdisk unpack & repack, we do not need it - cr: kdrag0n.
split_boot;
flash_boot;
## end install
