# Encryption Scripts

This folder contains a script to encrypt partitions.

## Scripts

### [Partition Encryption](partition_encryption.sh)

You can use this script to encrypt your partitions. For example u can use it to encrypt a partition on a usb device. The partition will be encrypted in this way:
- Random override using `dd`
- Encrypt partition using `cryptsetup` with `luks`
- Create `ext4` filesystem
