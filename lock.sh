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
    echo -e $RED"THIS SCRIPT MUST BE RUN AS ROOT."$END
    sleep 2
    exit 0
fi
#Start fresh
clear
# What's up
echo -e "$BLUE""This is the locking piece "$RED"lock.sh"$END" "$BLUE"of the"$END" "$RED"Cryption"$END" "$BLUE"tool.""$END"
echo -e "$BLUE""This piece will properly lock a usb/sd that was created with mounted with"$END" "$RED"unlock.sh""$END"
echo -e "$GRN""\nPress enter to see mounted devices""$END"
  read
echo -e "$PURP"
ls /media/
echo -e "$END"
echo -e "$BLUE""You should enter your choice like this:"$END" "$RED"sdc2""$END"
echo -e "$GRN""Which device do you want to close?""$END"
device ()
{
echo -e "$GRN""Device to close:""$END"
  echo -e "$CYAN"
  read DEVICE_ROOT
  echo -e "$END"
echo -e "$GRN""You chose device"$END" "$RED""$DEVICE_ROOT""$END" "$GRN"Is this correct? (yes/no).""$END"
  echo -e "$CYAN"
  read CORRECT_DEVICE
  echo -e "$END"
      export CORRECT_DEVICE="$CORRECT_DEVICE"
      export DEVICE_ROOT="$DEVICE_ROOT"
}
device
  while [[ "$CORRECT_DEVICE" != "yes" ]]
  do
      device
  done
echo -e "$BLUE""Alright, you chose device"$END" "$RED""$DEVICE_ROOT""$END""
echo -e "$BLUE""Ther can be no programs using this filesystem. Please take some time now""$END"
echo -e "$BLUE""to make sure this is not the case. Hint: close all windows and terminals.""$END"
echo -e "$GRN""Press enter to unmount and lock"$END" "$RED""$DEVICE_ROOT"""$END"
  read
umount /media/$DEVICE_ROOT
cryptsetup luksClose $DEVICE_ROOT
echo -e "$GRN""FILE SYSTEM UNMOUNTED AND LOCKED. YOUR FILES ARE SAFE.""$END"
echo -e "$GRN""USE"$END" "$RED"unlock.sh"$END" "$GRN"to unlock again.""$END"
echo -e "$GRN""Press enter to exit the script""$END"
exit 0
