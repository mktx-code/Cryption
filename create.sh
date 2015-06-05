#!/bin/bash
# Safety first
set -e
# Pretty
RED="\033[1;31m"
BLUE="\033[1;34m"
GRN="\033[1;32m"
PURP="\033[1;35m"
CYAN="\033[1;36m"
END="\033[0m"
# Has root?
if [ $UID -ne 0 ]; then
    echo -e $RED"This program must be run as root."$END
    sleep 2
    exit 0
fi
#Start fresh
clear
# What's up
echo -e "$BLUE""This is the creation piece "$RED"create.sh"$END" "$BLUE"of the"$END" "$RED"Cryption"$END" "$BLUE"tool.""$END"
echo -e "$BLUE""This piece will properly create a new usb for your secure storage.""$END"
echo -e "$BLUE""If you haven't, please put your usb/sdcard in now.""$END"
echo -e "$GRN""Press enter when you have the device in.""$END" 
  read
echo -e "$BLUE""\nHere is a list of the devices currently plugged in.""$END"
sleep 5
echo -e "$PURP"
fdisk -l | grep dev
echo -e "$END"
sleep 5
echo -e "$RED""\n/dev/sda"$END" "$BLUE"group most likely belongs to your harddrive.""$END"
echo -e "$BLUE""Unless you have no harddrive in the device.""$END"
echo -e "$RED""\n/dev/sdb"$END" "$BLUE"is most likely your device, unless you're using an os like Tails.""$END"
echo -e "$BLUE""In that case"$END" "$RED"/dev/sdb"$END" "$BLUE"is your Tails device (Hint: Tails only shows one partition).""$END"
echo -e "$RED""\n/dev/sdc"$END""$BLUE","$END" "$RED"/dev/sdd"$END""$BLUE", and so on are other devices."$END
echo -e "$BLUE""\nThey were each assigned a letter based on the order they were plugged in.""$END"
echo -e "$BLUE""Sd cards will be something like:"$END" "$RED"/dev/mmcblk0p""$END"
# Pick yer poison
echo -e "$GRN""Do you see your device here?"" (yes/no)$END"
  echo -e "$CYAN"   
  read DEVICE_HERE
  echo -e "$CYAN" 
    if [[ "$DEVICE_HERE" != "yes" ]]; then
        echo -e "$BLUE""Please insert the device now.""$END"
        echo -e "$GRN""Press enter when device is in.""$END"
          read
              echo -e "$BLUE""Here's the new list of devices. The one you just put in should be at the bottom.""$END"
              echo -e "$PURP"
              fdisk -l | grep dev 
              echo -e "$END"
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
echo -e "$GRN""You chose device"$END" "$RED""$DEVICE_ROOT""$END". "$GRN"Is this correct? (yes/no).""$END"
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
echo -e ""$BLUE"Here is the space/partitioning of"$END" "$RED""$DEVICE_ROOT":"$END
sleep 5
echo -e "$PURP"
fdisk -l "$DEVICE_ROOT"
echo -e "$END"
# Wipe
echo -e "$GRN""\nWould you like to begin by wiping the drive? (yes/no)""$END"
  echo -e "$CYAN"
  read WIPE
  echo -e "$END"
    if [[ "$WIPE" = "yes" ]]; then
        echo -e "$BLUE""\nEach pass takes about 10 minutes per GB.""$END"
        sleep 2
blockpasses ()
{
echo -e "$BLUE""\nHow many passes would you like to make with random data?""$END"
echo -e "$GRN""Enter the number of passes you would like to make. (1-10)""$GRN"
  echo -e "$CYAN"
  read OW_PASSES
  echo -e "$END"
  export OW_PASSES=$OW_PASSES
}
          blockpasses
            if [[ "$OW_PASSES" -gt "0" && "$OW_PASSES" -lt "11" ]]; then
                echo -e "$BLUE""You chose "$RED""$OW_PASSES"$END" "$BLUE""passes.""$END"
                echo -e "$PURP"
                badblocks -c 1024 -wsvt random -p $OW_PASSES $DEVICE_ROOT
                echo -e "$END"
            else
                echo -e "$RED""\nYou did not enter a valid number.\nPlease choose a number between 1 and 10.""$END"
                blockpasses
                  if [[ "$OW_PASSES" -gt "0" && "$OW_PASSES" -lt "11" ]]; then
                      echo -e "$BLUE""You chose "$RED""$OW_PASSES"$END" "passes.""$END"
                      echo -e "$PURP"
                      badblocks -c 1024 -wsvt random -p $OW_PASSES $DEVICE_ROOT
                      echo -e "$END"
                  else
                      echo -e "$RED""PLEASE KILL YOURSELF NOW FOR BEING UNABLE TO ENTER A NUMBER PROPERLY.""$END"
                      exit 0
                  fi
            fi
    else
# Just do it
        echo -e "$RED""\nIT IS NOT SECURE TO CONTINUE WITHOUT WIPING AT LEAST ONCE.""$END"
        echo -e "$GRN""\nDo you still want to continue without wiping? (yes/no)""$END"
          echo -e "$CYAN" 
          read INSECURE_CONTINUE
          echo -e "$END"
              if [[ "$INSECURE_CONTINUE" = yes ]]; then
                  sleep 1
              else
                  echo -e "$RED""\nPlease restart the script.""$END"
                  exit 0
              fi
    fi
sleep 1
# Partitioning. I will hold your hand on this one. See: README.create
echo -e "$BLUE""Now we need to partition the disk. The most sane way is using fdisk,""$END"
echo -e "$BLUE""however this will require you to do some things for yourself.""$END"
echo -e "$BLUE""\nThis part should be very easy, if you follow the reference. Please open the""$END"
echo -e "$RED""README.create""$END" "$BLUE""file. You can have it along side your terminal to see""$END" 
echo -e "$BLUE""how to do this part correctly.""$END"
echo -e "$GRN""Press enter when you're ready to enter fdisk.""$END"
  read
echo -e "$PURP" 
fdisk $DEVICE_ROOT
echo -e "$END" 
# Crypto time
echo -e "$BLUE""\nNow it is time to start encrypting.""$END"
echo -e "$BLUE""You are going to choose a password now that unlocks your first partition.""$END"
echo -e "$BLUE""This is "$RED"ONE"$END" "$BLUE"of"$END" "$RED"TWO"$END" "$BLUE"passwords that you will need to remember.""$END"
echo -e "$RED""\nIF YOU FORGET YOUR PASSWORD THERE IS NO WAY BACK INTO YOUR DEVICE!""$END"
echo -e "$BLUE""\nThis process may take a few minutes depending on your computer.\nPlease be patient and don't exit the script!""$END"
echo -e "$BLUE""You'll have to answer 'YES' to cryptsetup""$END"
echo -e "$GRN""Press enter when you're ready to move on.""$END"
  read
# Checksdcard function to correct the coming commands if sd card is present.
checksdcard ()
{
IS_SD="$(echo "$DEVICE_ROOT" | grep -c "mm")"
  if [ "$IS_SD" -gt "0" ]; then
      export DEVICE_ROOT=""$DEVICE_ROOT"p"
  fi
}
checksdcard
# First cascade with 15000 iterations and a passphrase
echo -e "$PURP"
cryptsetup luksFormat -i 15000 -c aes-cbc-essiv:sha256 "$DEVICE_ROOT"1
echo -e "$END"
echo -e "$BLUE""\nYou'll need to enter the first password one last time now.\n""$END"
sleep 3
SDX="$(echo -e "$DEVICE_ROOT" | cut -b 6-)"
echo -e "$PURP"
cryptsetup luksOpen "$DEVICE_ROOT"1 "$SDX"1
echo -e "$END"
# Make ext4 filesystem
echo -e "$BLUE""\nMaking a file system on the first partition now.\n""$END"
sleep 4
echo -e "$PURP"
mkfs.ext4 -t ext4 /dev/mapper/"$SDX"1
echo -e "$END"
rm -rf /media/"$SDX"1
mkdir /media/"$SDX"1
mount /dev/mapper/"$SDX"1 /media/"$SDX"1
echo -e "$BLUE""First partition is mounted.""$END"
sleep 5
echo -e "$BLUE""Now we will make the key files.""$END"
sleep 6
# Create 11 keyfiles. 0 - 10.
KEY_FILES_TOTAL=0
KEY_FILE=0
  while [[ "$KEY_FILES_TOTAL" -lt "11" ]]
  do
      head -c 2048 /dev/urandom > /media/"$SDX"1/key."$KEY_FILE"
      KEY_FILES_TOTAL=`expr "$KEY_FILES_TOTAL" + 1`
      KEY_FILE=`expr "$KEY_FILE" + 1`
  done
echo -e "$BLUE""\n11 key files have been created.""$END" 
echo -e "$BLUE""They are named "$RED"key.0"$END" "$BLUE"-"$END" "$RED"key.10"$END""$BLUE".""$END"
sleep 8
echo -e "$BLUE""They are located at"$END" "$RED"/media/"$SDX"1""$END" "$BLUE"."""$END"
echo -e "$GRN""Press enter to move on.""$END"
  read
echo -e "$BLUE""\nYou now need to choose which number key will be used\nto unlock the second partition which is where all of your data\nwill be stored.""$END"
echo -e "$RED""\nDO NOT FORGET WHICH KEY YOU CHOOSE\n""$END"
sleep 10
echo -e "$BLUE""Here is a list of the keys we just created.""$END"
echo -e "$BLUE""Don't worry we will remove 'lost+found' later.""$END"
echo -e "$GRN""\nPress enter to see the key list.""$END"
  read
echo -e "$PURP"
ls -al /media/"$SDX"1
echo -e "$END"
echo -e "$GRN""\nWhich number key file would you like to use? (0-10)""$END"
# Pick your key to unlock /dev/...2, and make sure it exists.
  echo -e "$CYAN" 
  read USER_KEY_PREF
  echo -e "$END" 
  USER_KEY_PREF_EXISTS="$(ls /media/"$SDX"1 | grep -ic "$USER_KEY_PREF")"
    if [[ "$USER_KEY_PREF_EXISTS" = "0" ]]; then
        echo "$RED""\nYOU DIDN'T ENTER AN EXISTING KEYFILE!""$END"
        echo "$GRN""\nWhich number key would you like to use? (0-10)""$END"
          echo -e "$CYAN" 
          read PREF_EXISTS_ADD
          echo -e "$END" 
              USER_KEY_PREF_EXISTS="$PREF_EXISTS_ADD"
    else
        echo -e "$BLUE""\nYou chose to use"$END" "$RED"key."$USER_KEY_PREF""$END"."
        sleep 4
    fi
mv /media/"$SDX"1/key."$USER_KEY_PREF" /tmp/
KEY_TO_CRYPT=0
  if [[ "$(ls /media/"$SDX"1/ | grep -ic key."$USER_KEY_PREF")" != 0 ]]; then
      echo -e "$RED""SOMETHING WICKED HAPPENED!""$END"
      exit 0
# Use pwgen to encrypt the keys not chosen by user for obfuscation.
  else
    while [[ "$KEY_TO_CRYPT" -lt "10" ]]
    do
      while [[ "$KEY_TO_CRYPT" -lt "$USER_KEY_PREF" ]]
      do
        gpg -q --passphrase "$(pwgen -n -c -y -B -s 18 1)" --symmetric --cipher-algo aes256 /media/"$SDX"1/key."$KEY_TO_CRYPT"
        KEY_TO_CRYPT=`expr $KEY_TO_CRYPT + 1`
      done
      while [[ "$KEY_TO_CRYPT" = "$USER_KEY_PREF" ]]
      do
        sleep 1
        KEY_TO_CRYPT=`expr $KEY_TO_CRYPT + 1`
      done
      while [[ "$KEY_TO_CRYPT" -lt "11" && "$KEY_TO_CRYPT" -gt "$USER_KEY_PREF" ]]
      do
<<<<<<< HEAD
        gpg -q --passphrase "$(pwgen -n -c -y -B -s 18 1)" --symmetric /media/"$SDX"1/key."$KEY_TO_CRYPT"
        KEY_TO_CRYPT=`expr "$KEY_TO_CRYPT" + 1`
=======
        gpg -q --passphrase "$(pwgen -n -c -y -B -s 18 1)" --symmetric --cipher-algo aes256 /media/"$SDX"1/key."$KEY_TO_CRYPT"
        KEY_TO_CRYPT=`expr "$KEY_TO_CRYPT" + 1`          
>>>>>>> c10df435cb1fad2d0f3bfdaf9bd21c928084d1aa
      done
    done
  fi
echo -e "$BLUE""\nNow you have to choose a password to encrypt your keyfile.""$END"
echo -e "$RED""\nTHIS IS THE SECOND PASSWORD YOU HAVE TO REMEMBER.""$END"
echo -e "$RED""\nDO NOT FORGET IT OR YOUR KEYFILE NUMBER!""$END"
echo -e "$GRN""\nPress enter to move on.""$END"
  read
# Need a passphrase for symmetric encryption of key
password ()
{
echo -e "$GRN""\nPassword:""$END"
read -s GPG_PASS_ONE
echo -e "$GRN""\nOne more time:""$END"
read -s GPG_PASS_TWO
export GPG_PASS_ONE=$GPG_PASS_ONE
export GPG_PASS_TWO=$GPG_PASS_TWO
}
password
# Make sure passwords match
  while [[ "$GPG_PASS_ONE" != "$GPG_PASS_TWO" ]]
  do
      echo -e "$RED""PASSWORDS DO NOT MATCH""$END"
      password
  done
# Encrypt users key with chosen passphrase
gpg -q --passphrase "$GPG_PASS_ONE" --symmetric --cipher-algo aes256 /tmp/key."$USER_KEY_PREF"
# Clean up those variables
GPG_PASS_ONE="foo"
GPG_PASS_TWO="foo"
mv /media/"$SDX"1/*.gpg /tmp/
echo -e "$BLUE""\nCleaning up unencrypted keys...""$END"
sleep 5
# Wipe unencrypted keys with 38 passes
echo -e "$PURP"
srm -drv /media/"$SDX"1/*
echo -e "$END"
mv /tmp/key.*.gpg /media/"$SDX"1
touch /media/"$SDX"1/*
echo -e "$BLUE""\nAll keys have been created, encrypted, and put onto"$END" "$RED"/dev/"$SDX"1""$END"
echo -e "$GRN""Press enter to see the finalized list of keys.""$END"
  read
echo -e "$PURP"
ls -al /media/"$SDX"1
echo -e "$END"
echo -e "$BLUE""\nUnmounting and closing"$END" "$RED"/dev/"$SDX"1""$END"
sleep 5
# Get rid of /dev/...1 properly, we don't need it since we have the key decrypted in /tmp/ still.
umount /media/"$SDX"1
cryptsetup luksClose "$SDX"1
rm -rf /media/"$SDX"1
echo -e "$BLUE""\nCreating the storage partition on"$END" "$RED"/dev/"$SDX"2.""$END"
echo -e "$BLUE""Encrypted with key file "$RED"key."$USER_KEY_PREF"""$END"
echo -e "$BLUE""This should take a few minutes depending on your computer.""$END"
echo -e "$BLUE""Please be patient. Do not exit the script!""$END"
echo -e "$BLUE""Please answer 'YES' to cryptsetup on last time.""$END"
echo -e "$GRN""Press enter to continue.""$END"
  read
# Second cascade with 15000 iterations and a key file
echo -e "$PURP"
cryptsetup luksFormat -i 15000 -c aes-xts-plain64 --key-file=/tmp/key."$USER_KEY_PREF" /dev/"$SDX"2
echo -e "$END"
# Open device to make the file system
cryptsetup luksOpen --key-file=/tmp/key."$USER_KEY_PREF" /dev/"$SDX"2 "$SDX"2
echo -e "$BLUE""\nPutting a file system on the second partition.\n""$END"
sleep 3
# File system
echo -e "$PURP"
mkfs.ext4 -t ext4 /dev/mapper/"$SDX"2
echo -e "$END"
echo -e "$BLUE""\nClosing"$END" "$RED"/dev/"$SDX"2"$END" "$BLUE"and cleaning up.""$END"
sleep 5
# Close device
cryptsetup luksClose "$SDX"2
# Secure-delete unencrypted key
echo -e "$PURP"
srm -drv /tmp/key*
echo -e "$END"
echo -e "$GRN""FINISHED. YOU CAN MOVE TO THE FILE"$END" "$RED"unlock.sh"$END" "$GRN"TO OPEN YOUR DEVICE.""$END"
echo -e "$GRN""Press enter to exit the script.""$END"
  read
exit 0
