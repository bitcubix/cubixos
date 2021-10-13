# KVM-QEMU

KVM/QEMU/Virt-Manager is a hypervisor and a good alternative to Virtualbox.
Performance should be better using this combination since KVM is built into the Linux kernel itself. 
And it's not difficult to convert your existing Virtualbox VM's over to Virt-Manager.

This folder contains script for setup and using `KVM (Kernel based Virtual MAchine) using QEMU (Virt-manager as frontend)`.

## Resources
- ### Documentation
  - Arch wiki for [KVM](https://wiki.archlinux.org/title/KVM)
  - Arch wiki for [QEMU](https://wiki.archlinux.org/title/QEMU)
- ### Youtube Tutorials
| TOPIC                                            | SOURCE NAME            | LINK                                                            |
| ------------------------------------------------ | ---------------------  | --------------------------------------------------------------- |
| Intro to KVM & creating Virtual Machines         | Distrotube (DT)        | [click here](https://www.youtube.com/watch?v=p1d_b_91YlU)       |
| Creating virtual machines (without any frontend) | Kris Occhipinti        | [click here](https://www.youtube.com/watch?v=JxSGT_3UU8w)       |
| installing KVM and making virtual machines       | Linux made simple      | [click here](https://www.youtube.com/watch?v=itZf5FpDcV0)       |


## Scripts

### [kvm-qemu_setup](kvm-qemu_setup.sh)

You can use this script to install KVM, QEMU, Virt-manager and all the necessary packages for virtualization

The scrip:
- Enables ans starts `systemd` services
- Adds your login account to necessary groups
- Configures a bridge between host and guest machines
