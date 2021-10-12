# Encryption Scripts

This folder contains script to encrypt partitions or devices.

## Scripts

### [Partition Encryption](partition_encryption.sh)

You can use this script to encrypt your partitions. The partition will be encrypted in this way:
- NULL override using `dd`
- encrypt partition using `cryptsetup` with `luks`
- create `ext4` filesystem
