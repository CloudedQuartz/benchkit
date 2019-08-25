##########################################################################################
#
# Unity Config Script
# by topjohnwu, modified by Zackptg5
#
##########################################################################################

##########################################################################################
# Unity Logic - Don't change/move this section
##########################################################################################

if [ -z $UF ]; then
  UF=$TMPDIR/common/unityfiles
  unzip -oq "$ZIPFILE" 'common/unityfiles/util_functions.sh' -d $TMPDIR >&2
  [ -f "$UF/util_functions.sh" ] || { ui_print "! Unable to extract zip file !"; exit 1; }
  . $UF/util_functions.sh
fi

comp_check

##########################################################################################
# Config Flags
##########################################################################################

# Uncomment and change 'MINAPI' and 'MAXAPI' to the minimum and maximum android version for your mod
# Uncomment DYNLIB if you want libs installed to vendor for oreo+ and system for anything older
# Uncomment SYSOVER if you want the mod to always be installed to system (even on magisk) - note that this can still be set to true by the user by adding 'sysover' to the zipname
# Uncomment DEBUG if you want full debug logs (saved to /sdcard in magisk manager and the zip directory in twrp) - note that this can still be set to true by the user by adding 'debug' to the zipname
#MINAPI=21
#MAXAPI=25
#DYNLIB=true
#SYSOVER=true
#DEBUG=true

# Uncomment if you do *NOT* want Magisk to mount any files for you. Most modules would NOT want to set this flag to true
# This is obviously irrelevant for system installs. This will be set to true automatically if your module has no files in system
#SKIPMOUNT=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
# Custom Logic
##########################################################################################

center_and_print_min() {
  ui_print " "
  local NEW CHARS SPACES
  for i in version author; do
    NEW=$(grep_prop $i $TMPDIR/module.prop)
    [ "$i" == "author" ] && NEW="by ${NEW}"
    CHARS=$((${#NEW}-$(echo "$NEW" | tr -cd "©®™" | wc -m)))
    SPACES=""
    if [ $CHARS -le 40 ]; then
      for j in $(seq $(((40-$CHARS) / 2))); do
        SPACES="${SPACES} "
      done
    fi
    ui_print "$SPACES$NEW$SPACES"
  done
  ui_print " "
}

# Set what you want to display when installing your module

print_modname() {
  cat <<END

 ____                  _     _    _ _
| __ )  ___ _ __   ___| |__ | | _(_) |_
|  _ \ / _ \ '_ \ / __| '_ \| |/ / | __|
| |_) |  __/ | | | (__| | | |   <| | |_
|____/ \___|_| |_|\___|_| |_|_|\_\_|\__|
END
  center_and_print_min

  unity_main # Don't change this line
}

set_permissions() {
  # Note that all files/folders have the $UNITY prefix - keep this prefix on all of your files/folders
  # Also note the lack of '/' between variables - preceding slashes are already included in the variables
  # Use $VEN for vendor (Do not use /system$VEN, the $VEN is set to proper vendor path already - could be /vendor, /system/vendor, etc.)

  # Some examples:

  # For directories (includes files in them):
  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)

  # set_perm_recursive $UNITY/system/lib 0 0 0755 0644
  # set_perm_recursive $UNITY$VEN/lib/soundfx 0 0 0755 0644

  # For files (not in directories taken care of above)
  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)

  # set_perm $UNITY/system/lib/libart.so 0 0 0644

  set_perm_recursive $UNITY/system/bin 0 0 0755 0755
  set_perm_recursive $UNITY/system/xbin 0 0 0755 0755
}

# Custom Variables for Install AND Uninstall - Keep everything within this function - runs before uninstall/install
unity_custom() {
  : # Remove this if adding to this function
}

# Custom Functions for Install AND Uninstall - You can put them here
