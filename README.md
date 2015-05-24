# Cryption
Tools for creating, opening/using, and closing a usb/sd encrypted with cryptsetup and gpg. 


## Get the code
1. git clone https://github.com/mktx-code/Cryption
2. cd Cryption
3. chmod +x *.sh
4. MUST BE RUN AS ROOT!
5. Run the relevant script.
  A. ./create.sh
  B. ./unlock.sh
  C. ./lock.sh



### ./create.sh

1. Pick an external storage device. 
2. Wipe device using badblocks, number of passes specified by user. 
3. Device is then partitioned to two primary partitions. One being 5MB for key storage, and the second being the remainder of the device. 
4. The first partition is then encrytped using: cryptsetup luksFormat -i 15000 -c aes-cbc-essiv:sha256 and a user defined password. 
5. Next this partition is populated with 10 keys. One of which the user will choose to encrypt the second partition. 
6. The user will also choose a second passphrase to lock their keyfile using gpg symmetric encryption. 
7. The other keyfiles are encrypted with random passwords. 
8. Second partition is encrypted using: cryptsetup luksFormat -i 15000 -c aes-xts-plain64 and a key file chosen by the user.
9. Everything is cleaned up nice and neat.

### ./unlock.sh

1. Pick device.
2. Unlock partition 1.
3. Decrypt key file.
4. Use key file to open partition 2.
5. Securely remove decrypted keyfile.
6. Unmount and lock partition 1.

### ./lock.sh


