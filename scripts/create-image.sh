#!/bin/bash

IMG=/tmp/os-test.img

printf "Createing disk image: %s\n" $IMG
qemu-img create -f qcow2 $IMG 1G
