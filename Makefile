ASM = nasm
CC = clang
LD = ld

IMG=/tmp/test-os.img
BOOT=./bin/boot
LOADER=./bin/loader

.PHONY: clean

all:
	@make create_image
	@make build
	@make install

run: 
	@printf "Booting %s\n" $ISO_IMAGE
	qemu-system-i386 -enable-kvm -drive file=$(IMG) -smp 1 -m 1G
	# -cpu host

build: src/*.asm
	@printf "Building bootloader...\n"
	if [[ ! -d "bin" ]]; then mkdir bin; fi
	$(ASM) -f bin -o $(BOOT) ./src/boot.asm
	$(ASM) -f bin -o $(LOADER) ./src/loader.asm

install:
	@printf "Writing disk image...\n"
	dd if=$(BOOT) of=$(IMG) bs=512 count=1 conv=notrunc
	dd if=$(LOADER) of=$(IMG) bs=512 count=5 seek=1 conv=notrunc

clean:
	@printf "Removing binaries...\n"
	rm -f ./bin/*
	@make delete_image

create_image:
	@printf "Createing disk image: %s\n" $(IMG)
	qemu-img create -f qcow2 $(IMG) 1G

delete_image:
	@printf "Deleteing disk image: %s\n" $(IMG)
	rm $(IMG)


