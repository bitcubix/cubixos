# Basic Arch Linux Install
This folder contains everthing you need for a basic Arch Linux installation.

You can use the script to create a boot stick and run the installation (run my personal installation).

IF you want to run the installation by yourself you can follow the [step by step installation.](base_install.md)

[create boot stick script](create_boot_stick.sh)

For the base install script clone the whole repo because you need multiple file.
```bash
pacman -Sy
pacman -S git
git clone https://github.com/bitcubix/arch
```

To run the script:
```bash
cd arch
bash base_install.sh
```

