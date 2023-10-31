### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Fate by dndxtz @ GitHub
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=crownlte
device.name2=star2lte
device.name3=starlte
device.name4=
device.name5=
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

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

# Uclamp tunables
if [ -f /dev/cpuset/top-app/uclamp.max ]; then
	ui_print "  • Uclamp supported kernel"
  #Uclamp tuning
  sysctl -w kernel.sched_util_clamp_min_rt_default=96
  sysctl -w kernel.sched_util_clamp_min=128

  #top-app
  echo max > /dev/cpuset/top-app/uclamp.max
  echo 20  > /dev/cpuset/top-app/uclamp.min
  echo 1   > /dev/cpuset/top-app/uclamp.boosted
  echo 1   > /dev/cpuset/top-app/uclamp.latency_sensitive

  #foreground
  echo 50 > /dev/cpuset/foreground/uclamp.max
  echo 20 > /dev/cpuset/foreground/uclamp.min
  echo 0  > /dev/cpuset/foreground/uclamp.boosted
  echo 0  > /dev/cpuset/foreground/uclamp.latency_sensitive

  #background
  echo max > /dev/cpuset/background/uclamp.max
  echo 20  > /dev/cpuset/background/uclamp.min
  echo 0   > /dev/cpuset/background/uclamp.boosted
  echo 0   > /dev/cpuset/background/uclamp.latency_sensitive

  #system-background
  echo 50 > /dev/cpuset/system-background/uclamp.max
  echo 10 > /dev/cpuset/system-background/uclamp.min
  echo 0  > /dev/cpuset/system-background/uclamp.boosted
  echo 0  > /dev/cpuset/system-background/uclamp.latency_sensitive

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

