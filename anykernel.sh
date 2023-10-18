### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Fate by dndxtz @ GitHub
do.devicecheck=0
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
} # end attributes

# boot shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# Backup the partition
if dd if=${block} of=/sdcard/backup-boot.img; then
  ui_print ""
  ui_print "Your backup boot image has been saved to: /sdcard/backup-boot.img"
  ui_print ""
fi

# If lk2nd is installed, Read boot from 1MB offset
if [ "$(dd if=${block} skip=64 bs=1 count=5 2>/dev/null)" == "lk2nd" ]; then
  ui_print "Detected lk2nd installation! Skipping the first 1MB."
  customdd="bs=1M skip=1"
  lk2nd=1
fi

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

# If lk2nd is installed, Write boot to 1MB offset
if [ "$lk2nd" == "1" ]; then
  customdd="bs=1M seek=1"
  # GNU GREP: lk2nd_end=$(expr $(grep --byte-offset --only-matching --text SEANDROIDENFORCE ${block}|cut -d ':' -f 1) + 16)
  # AK3 grep: lk2nd_end=$(expr $(grep -o -n SEANDROIDENFORCE ${block}|cut -d ':' -f 1) + 16)
  # Recovery grep:
  lk2nd_end=$(expr $(/bin/grep -o -b -a SEANDROIDENFORCE ${block}|cut -d ':' -f 1) + 16)
  lk2nd_gaps=$(expr 1048576 - ${lk2nd_end})
  ui_print "Filling ${lk2nd_gaps} bytes of gap from lk2nd data (${lk2nd_end}) till 1MB with zeroes."
  dd if=/dev/zero of=$block bs=1 count=$lk2nd_gaps seek=$lk2nd_end
fi

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install


## init_boot files attributes
#init_boot_attributes() {
#set_perm_recursive 0 0 755 644 $ramdisk/*;
#set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
#} # end attributes

# init_boot shell variables
#block=init_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for init_boot patching
#reset_ak;

# init_boot install
#dump_boot; # unpack ramdisk since it is the new first stage init ramdisk where overlay.d must go

#write_boot;
## end init_boot install


## vendor_kernel_boot shell variables
#block=vendor_kernel_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for vendor_kernel_boot patching
#reset_ak;

# vendor_kernel_boot install
#split_boot; # skip unpack/repack ramdisk, e.g. for dtb on devices with hdr v4 and vendor_kernel_boot

#flash_boot;
## end vendor_kernel_boot install


## vendor_boot files attributes
#vendor_boot_attributes() {
#set_perm_recursive 0 0 755 644 $ramdisk/*;
#set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;
#} # end attributes

# vendor_boot shell variables
#block=vendor_boot;
#is_slot_device=1;
#ramdisk_compression=auto;
#patch_vbmeta_flag=auto;

# reset for vendor_boot patching
#reset_ak;

# vendor_boot install
#dump_boot; # use split_boot to skip ramdisk unpack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot

#write_boot; # use flash_boot to skip ramdisk repack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot
## end vendor_boot install

