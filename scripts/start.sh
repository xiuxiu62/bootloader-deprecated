#!/bin/bash

IMG=/tmp/os-test.img

printf "Booting %s\n" $ISO_IMAGE
qemu-system-i386 -enable-kvm -drive file=$IMG -smp 1 -m 1G
# -cpu host
