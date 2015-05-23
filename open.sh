#!/bin/bash
# Safety first
set -e
# Pretty
RED="\033[0;31m"
BLUE="\033[0;34m"
GRN="\033[0;32m"
PURP="\033[1;35m"
CYAN="\033[0;36m"
END="\033[0m"
# Haz rootz nao?
if [ $UID -ne 0 ]; then
    echo -e $RED"This program must be run as root."$END
    sleep 2
    exit 0
fi
# What's up
echo -e "$BLUE""This is the open piece "$RED"open.sh"$END" "$BLUE"of the"$END" "$RED"Cryption"$END" "$BLUE"tool.""$END"
sleep 3
echo -e "$BLUE""This piece will properly open a new usb/sd that was created with"$END" "$RED"open.sh""$END"
sleep 5
echo -e "$BLUE""If you haven't, please put your usb/sdcard in now.""$END"
echo -e "$GRN""Press enter when you have the device in.""$END"
  read
echo -e "$BLUE""\nHere is a list of the devices currently plugged in that were made using"$END" "$RED"create.sh""$END"
sleep 5
fdisk -l | grep -i lvm
sleep 5
# Pick yer poison
echo -e "$GRN""Do you see your device here?"" (yes/no)$END"
  read DEVICE_HERE
    if [[ "$DEVICE_HERE" != "yes" ]]; then
        echo -e "$BLUE""Please insert the device now.""$END"
        echo -e "$GRN""Press enter when device is in.""$END"
          read
              echo -e "$BLUE""Here's the new list of devices. The one you just put in should be at the bottom.""$END"
              fdisk -l | grep dev 
    else
        sleep 1
    fi
echo -e "$BLUE""\nPlease select the device you wish to work on.\nDo not include the partition number if it exists.""$END"
sleep 2
echo -e "$BLUE""Example:"$END" "$RED"/dev/sdc""$END"
sleep 2
# Device function
device ()
{
echo -e "$GRN""Device to work with:""$END"
  read DEVICE_ROOT
echo -e "$GRN""You chose device"$END" "$RED""$DEVICE_ROOT""$END" "$BLUE"Is this correct? (yes/no).""$END"
  read CORRECT_DEVICE
      export CORRECT_DEVICE="$CORRECT_DEVICE"
      export DEVICE_ROOT="$DEVICE_ROOT"
}
device
  while [[ "$CORRECT_DEVICE" != "yes" ]]
  do
      device
  done
echo -e "$BLUE""Alright, you have chosen device"$END" "$RED""$DEVICE_ROOT""$END""
sleep 3
# Check to make sure it has luks volumes
echo -e "$BLUE""Checking for proper volumes on device...""$END"
