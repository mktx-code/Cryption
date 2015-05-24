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
echo -e "$BLUE""This is the unlocking piece "$RED"unlock.sh"$END" "$BLUE"of the"$END" "$RED"Cryption"$END" "$BLUE"tool.""$END"
echo -e "$BLUE""This piece will properly unlock and mount a usb/sd that was created with"$END" "$RED"open.sh""$END"
echo -e "$BLUE""If you haven't, please put your usb/sdcard in now.""$END"
echo -e "$GRN""Press enter when you have the device in.""$END"
  read
echo -e "$BLUE""\nHere is a list of the devices currently plugged in that\nwere possibly made using"$END" "$RED"create.sh""$END"
sleep 2
echo -e "$PURP"
fdisk -l | grep -i lvm
echo -e "$END"
sleep 5
# Pick yer poison
echo -e "$GRN""Do you see your device here?"" (yes/no)$END"
  echo -e "$CYAN"
  read DEVICE_HERE
  echo -e "$END"
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
echo -e "$BLUE""Example:"$END" "$RED"/dev/sdc""$END"
# Device function
device ()
{
echo -e "$GRN""Device to work with:""$END"
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
echo -e "$BLUE""Alright, you have chosen device"$END" "$RED""$DEVICE_ROOT""$END""
sleep 3
SDX="$(echo -e "$DEVICE_ROOT" | cut -b 6-)"
# Check to make sure it has luks volumes
echo -e "$BLUE""Checking for proper volumes on device...""$END"
HAS_LUKS_ONE="$(cryptsetup luksDump /dev/"$SDX"1 | grep -c "ENABLED")"
HAS_LUKS_TWO="$(cryptsetup luksDump /dev/"$SDX"2 | grep -c "ENABLED")"
  if [[ "$HAS_LUKS_ONE" = "0" || "$HAS_LUKS_TWO" = "0" ]]; then
      echo -e "$RED""THIS DEVICE IS NOT COMPATABLE! PLEASE REMOVE AND INSERT\nTHE CORRECT DISK OR EXIT THE SCRIPT WITH 'Ctrl-c'""$END"
      echo -e "$GRN""Press enter to continue.""$END"
      device
  else
      sleep 1
  fi
echo -e "$BLUE""Decrypting"$END" "$RED"/dev/"$SDX"1"$END""$BLUE". Please be patient during this step.""$END"
sleep 3
echo -e "$GRN"
cryptsetup luksOpen /dev/"$SDX"1 "$SDX"1
echo -e "$END"
rm -rf /media/"$SDX"1
mkdir /media/"$SDX"1
mount /dev/mapper/"$SDX"1 /media/"$SDX"1
echo -e "$BLUE""First partition mounted. Now we need to decrypt your keyfile.""$END"
echo -e "$GRN""Press enter to see a list of your keyfiles.""$END"
  read
echo -e "$PURP"
ls -al /media/"$SDX"1
echo -e "$END"
echo -e "$GRN""Which key do you want to decrypt? (0-10)""$END"
# Pick your key to unlock /dev/...2, and make sure it exists
echo -e "$CYAN" 
  read KEY_FILE
echo -e "$END" 
USER_KEY_PREF_EXISTS="$(ls /media/"$SDX"1 | grep -ic "$KEY_FILE")"
  if [[ "$USER_KEY_PREF_EXISTS" = "0" ]]; then
      echo "$RED""\nYOU DIDN'T ENTER AN EXISTING KEYFILE!""$END"
      echo "$GRN""\nWhich number key would you like to use? (0-10)""$END"
      echo -e "$CYAN" 
      read PREF_EXISTS_ADD
      echo -e "$END" 
      USER_KEY_PREF_EXISTS="$PREF_EXISTS_ADD"
  else
      echo -e "$BLUE""\nYou chose to use"$END" "$RED"key."$KEY_FILE""$END"."
      sleep 4
  fi
echo -e "$BLUE""\nNow we must decrypt the key in order to unlock the data on"$END" "$RED""$SDX"2""$END"
echo -e "$BLUE""The next step will ask for the password for you keyfile.""$END"
echo -e "$BLUE""In order to keep your decrypted key off the disk as much as possible""$END"
echo -e "$BLUE""the script will move through a few steps after this with no explanation.""$END"
echo -e "$GRN""\nPress enter to move on.""$END"
  read
# Need a passphrase for dcryption of key
# Decrypt key and store it temporarily
echo -e "$GRN"
gpg -q -d /media/"$SDX"1/key."$KEY_FILE".gpg > /tmp/key
echo -e "$END"
# Open and mount partition 2
cryptsetup --key-file=/tmp/key luksOpen /dev/"$SDX"2 "$SDX"2
echo -e "$PURP"
srm -drv /tmp/key
echo -e "$END"
rm -rf /media/"$SDX"2 
mkdir /media/"$SDX"2
mount /dev/mapper/"$SDX"2 /media/"$SDX"2
# Clean up 
umount /media/"$SDX"1
cryptsetup luksClose "$SDX"1
rm -rf /media/"$SDX"1
echo -e "$GRN""\nTHE SCRIPT HAS FINISHED. YOUR DECRYPTED FILE SYSTEM IS LOCATED AT"$END" "$RED"/media/"$SDX"2""$END"
echo -e "$GRN""TO CLOSE THE DEVICE RUN THE"$END" "$RED"lock.sh"$END" "$GRN"SCRIPT""$END"
echo -e "$RED""\nDO NOT REMOVE THE DEVICE!!""$END"
echo -e "$RED""REMOVING THE DEVICE WITHOUT EXITING PROPERLY CAN CORRUPT THE DATA!!""$END"
echo -e "$GRN""\nPress enter to exit the script.""$END"
  read
exit 0

